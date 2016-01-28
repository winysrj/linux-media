Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58328 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946069AbcA1RPk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 12:15:40 -0500
Date: Thu, 28 Jan 2016 15:15:22 -0200
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
Subject: Re: [PATCH 04/31] media: Media Controller enable/disable source
 handler API
Message-ID: <20160128151522.03dff6cd@recife.lan>
In-Reply-To: <56AA41B5.1080703@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<d8d65a0188b05f3e799400c745584a02bc9b7548.1452105878.git.shuahkh@osg.samsung.com>
	<20160128131922.29e2a504@recife.lan>
	<56AA41B5.1080703@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jan 2016 09:28:37 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 01/28/2016 08:19 AM, Mauro Carvalho Chehab wrote:
> > Em Wed,  6 Jan 2016 13:26:53 -0700
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >   
> >> Add new fields to struct media_device to add enable_source, and
> >> disable_source handlers, and source_priv to stash driver private
> >> data that is need to run these handlers. The enable_source handler
> >> finds source entity for the passed in entity and check if it is
> >> available, and activate the link using __media_entity_setup_link()
> >> interface. Bridge driver is expected to implement and set these
> >> handlers and private data when media_device is registered or when
> >> bridge driver finds the media_device during probe. This is to enable
> >> the use-case to find tuner entity connected to the decoder entity and
> >> check if it is available, and activate it and start pipeline between
> >> the source and the entity. The disable_source handler deactivates the
> >> link and stops the pipeline. This handler can be invoked from the
> >> media core (v4l-core, dvb-core) as well as other drivers such as ALSA
> >> that control the media device.
> >>
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >>  include/media/media-device.h | 19 +++++++++++++++++++
> >>  1 file changed, 19 insertions(+)
> >>
> >> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >> index 6520d1c..04b6c2e 100644
> >> --- a/include/media/media-device.h
> >> +++ b/include/media/media-device.h
> >> @@ -333,6 +333,25 @@ struct media_device {
> >>  	/* Serializes graph operations. */
> >>  	struct mutex graph_mutex;
> >>  
> >> +	/* Handlers to find source entity for the sink entity and
> >> +	 * check if it is available, and activate the link using
> >> +	 * media_entity_setup_link() interface and start pipeline
> >> +	 * from the source to the entity.
> >> +	 * Bridge driver is expected to implement and set the
> >> +	 * handler when media_device is registered or when
> >> +	 * bridge driver finds the media_device during probe.
> >> +	 * Bridge driver sets source_priv with information
> >> +	 * necessary to run enable/disable source handlers.
> >> +	 *
> >> +	 * Use-case: find tuner entity connected to the decoder
> >> +	 * entity and check if it is available, and activate the
> >> +	 * using media_entity_setup_link() if it is available.
> >> +	*/
> >> +	void *source_priv;
> >> +	int (*enable_source)(struct media_entity *entity,
> >> +			     struct media_pipeline *pipe);
> >> +	void (*disable_source)(struct media_entity *entity);  
> > 
> > Please document the new fields at the right place (Kernel-doc
> > comment declared before the struct).
> > 
> > Is this used by the media core? If so, please but the implementation
> > here, to make it clearer why we need those things.
> >   
> >> +
> >>  	int (*link_notify)(struct media_link *link, u32 flags,
> >>  			   unsigned int notification);
> >>  };  
> 
> Hi Mauro,
> 
> I don't have any problems adding documentation. I would
> like to add documentation in a add-on to the patch series.
> The main reason is once I add documentation to this patch,
> the rest of the patches on this file don't apply and require
> rebase and rework. I went though a couple of rounds of this
> while you were adding documentation to the interfaces you
> added.
> 
> How about I add the documentation patches at the end of
> the patch series? I am concerned that rebasing for the
> documentation changes will introduce bugs. Are you okay
> with this proposal?

I'm ok with that for those inlined kernel-doc stuff. On
the changes at the uapi/linux/media.h, I would prefer if
you could add the documentation together with the patch,
as it makes clearer for the reviewers. As you only
touched it on one or two patches, this won't cause any
breakages on the remaining patches.

Regards,
Mauro



> 
> thanks,
> -- Shuah
> 
