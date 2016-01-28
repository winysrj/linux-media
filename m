Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58380 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945990AbcA1R3F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 12:29:05 -0500
Date: Thu, 28 Jan 2016 15:28:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH 29/31] media: track media device unregister in progress
Message-ID: <20160128152843.5ce581fa@recife.lan>
In-Reply-To: <56AA4A18.8030303@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<151cfbe0e59b3d5396951bdcc29666614575f5bc.1452105878.git.shuahkh@osg.samsung.com>
	<20160128150105.06a9a18d@recife.lan>
	<56AA4A18.8030303@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jan 2016 10:04:24 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 01/28/2016 10:01 AM, Mauro Carvalho Chehab wrote:
> > Em Wed,  6 Jan 2016 13:27:18 -0700
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >   
> >> Add support to track media device unregister in progress
> >> state to prevent more than one driver entering unregister.
> >> This enables fixing the general protection faults while
> >> snd-usb-audio was cleaning up media resources for pcm
> >> streams and mixers. In this patch a new interface is added
> >> to return the unregister in progress state. Subsequent
> >> patches to snd-usb-audio and au0828-core use this interface
> >> to avoid entering unregister and attempting to unregister
> >> entities and remove devnodes while unregister is in progress.
> >> Media device unregister removes entities and interface nodes.  
> > 
> > Hmm... isn't the spinlock enough to serialize it? It seems weird the
> > need of an extra bool here to warrant that this is really serialized.
> >   
> 
> The spinlock and check for media_devnode_is_registered(&mdev->devnode)
> aren't enough to ensure only one driver enters the unregister. 
>
> Please
> note that the devnode isn't marked unregistered until the end in
> media_device_unregister().

I guess the call to:
	device_remove_file(&mdev->devnode.dev, &dev_attr_model);

IMO, This should be, instead, at media_devnode_unregister().

Then, we can change the logic at media_devnode_unregister() to:

void media_devnode_unregister(struct media_devnode *mdev)
{
	mutex_lock(&media_devnode_lock);

	/* Check if mdev was ever registered at all */
	if (!media_devnode_is_registered(mdev)) {
		mutex_unlock(&media_devnode_lock);
		return;
	}

	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
	mutex_unlock(&media_devnode_lock);
	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
	device_unregister(&mdev->dev);
}

This sounds enough to avoid device_unregister() or device_remove_file()
to be called twice.

> 
> 
> >>
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >>  drivers/media/media-device.c |  5 ++++-
> >>  include/media/media-device.h | 17 +++++++++++++++++
> >>  2 files changed, 21 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >> index 20c85a9..1bb9a5f 100644
> >> --- a/drivers/media/media-device.c
> >> +++ b/drivers/media/media-device.c
> >> @@ -749,10 +749,13 @@ void media_device_unregister(struct media_device *mdev)
> >>  	spin_lock(&mdev->lock);
> >>  
> >>  	/* Check if mdev was ever registered at all */
> >> -	if (!media_devnode_is_registered(&mdev->devnode)) {
> >> +	/* check if unregister is in progress */
> >> +	if (!media_devnode_is_registered(&mdev->devnode) ||
> >> +	    mdev->unregister_in_progress) {
> >>  		spin_unlock(&mdev->lock);
> >>  		return;
> >>  	}
> >> +	mdev->unregister_in_progress = true;
> >>  
> >>  	/* Remove all entities from the media device */
> >>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> >> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >> index 04b6c2e..0807292 100644
> >> --- a/include/media/media-device.h
> >> +++ b/include/media/media-device.h
> >> @@ -332,6 +332,10 @@ struct media_device {
> >>  	spinlock_t lock;
> >>  	/* Serializes graph operations. */
> >>  	struct mutex graph_mutex;
> >> +	/* Tracks unregister in progress state to prevent
> >> +	 * more than one driver entering unregister
> >> +	*/
> >> +	bool unregister_in_progress;
> >>  
> >>  	/* Handlers to find source entity for the sink entity and
> >>  	 * check if it is available, and activate the link using
> >> @@ -365,6 +369,7 @@ struct media_device {
> >>  /* media_devnode to media_device */
> >>  #define to_media_device(node) container_of(node, struct media_device, devnode)
> >>  
> >> +
> >>  /**
> >>   * media_entity_enum_init - Initialise an entity enumeration
> >>   *
> >> @@ -553,6 +558,12 @@ struct media_device *media_device_get_devres(struct device *dev);
> >>   * @dev: pointer to struct &device.
> >>   */
> >>  struct media_device *media_device_find_devres(struct device *dev);
> >> +/* return unregister in progress state */
> >> +static inline bool media_device_is_unregister_in_progress(
> >> +					struct media_device *mdev)
> >> +{
> >> +	return mdev->unregister_in_progress;
> >> +}
> >>  
> >>  /* Iterate over all entities. */
> >>  #define media_device_for_each_entity(entity, mdev)			\
> >> @@ -569,6 +580,7 @@ struct media_device *media_device_find_devres(struct device *dev);
> >>  /* Iterate over all links. */
> >>  #define media_device_for_each_link(link, mdev)			\
> >>  	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
> >> +
> >>  #else
> >>  static inline int media_device_register(struct media_device *mdev)
> >>  {
> >> @@ -604,5 +616,10 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
> >>  {
> >>  	return NULL;
> >>  }
> >> +static inline bool media_device_is_unregister_in_progress(
> >> +					struct media_device *mdev)
> >> +{
> >> +	return false;
> >> +}
> >>  #endif /* CONFIG_MEDIA_CONTROLLER */
> >>  #endif  
> 
> 
