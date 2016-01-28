Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58472 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934134AbcA1Re4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 12:34:56 -0500
Date: Thu, 28 Jan 2016 15:34:39 -0200
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
Subject: Re: [PATCH 09/31] media: v4l2-core add
 v4l_vb2q_enable_media_tuner() helper
Message-ID: <20160128153439.4bdfe6fe@recife.lan>
In-Reply-To: <56AA5069.4010402@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<ac1ad6fc9832cb922ac02eba1f916a6fb4ef97a8.1452105878.git.shuahkh@osg.samsung.com>
	<20160128132937.3305eff3@recife.lan>
	<56AA5069.4010402@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jan 2016 10:31:21 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 01/28/2016 08:29 AM, Mauro Carvalho Chehab wrote:
> > Em Wed,  6 Jan 2016 13:26:58 -0700
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >   
> >> Add a new v4l_vb2q_enable_media_tuner() wrapper function
> >> to be called from v4l2-core to enable the media tuner with
> >> videobuf2 queue, when the calling frunction has the videobuf2
> >> queue and doesn't have the struct video_device associated with
> >> the queue handy as in the case of vb2_core_streamon(). This
> >> function simply calls v4l_enable_media_tuner() passing in the
> >> pointer to struct video_device.
> >>
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-dev.c | 21 +++++++++++++++++++++
> >>  include/media/v4l2-dev.h           |  1 +
> >>  2 files changed, 22 insertions(+)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> >> index f06da6e..9ef675a 100644
> >> --- a/drivers/media/v4l2-core/v4l2-dev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> >> @@ -30,6 +30,7 @@
> >>  #include <media/v4l2-common.h>
> >>  #include <media/v4l2-device.h>
> >>  #include <media/v4l2-ioctl.h>
> >> +#include <media/videobuf2-core.h>
> >>  
> >>  #define VIDEO_NUM_DEVICES	256
> >>  #define VIDEO_NAME              "video4linux"
> >> @@ -261,6 +262,26 @@ void v4l_disable_media_tuner(struct video_device *vdev)
> >>  }
> >>  EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
> >>  
> >> +/**
> >> + * v4l_vb2q_enable_media_tuner - Wrapper for v4l_enable_media_tuner()
> >> + * @q:         videobuf2 queue
> >> + *
> >> + * This function is intended to be called from v4l2-core
> >> + * to enable the media tuner with videobuf2 queue, when
> >> + * the calling frunction has the videobuf2 queue and doesn't  
> > 
> > 	typo: function  
> 
> ok thanks
> 
> >   
> >> + * have the struct video_device associated with the
> >> + * queue handy as in the case of vb2_core_streamon(). This
> >> + * function simply calls v4l_enable_media_tuner() passing
> >> + * in the pointer to struct video_device.  
> > 
> > The hole description seems confusing. I'm not seeing the light
> > about why this is needed.  
> 
> Sorry if the description isn't clear. During videobuf2
> work, owner field in struct vb2_queue is changed from
> struct v4l2_fh * to void. Prior to this work, I could
> call v4l_enable_media_tuner(). 
> 
> +               ret = v4l_enable_media_tuner(q->owner->vdev);
> +               if (ret)
> +                       return ret;
> 
> As you can see with the videobuf2, to be able to call
> v4l_enable_media_tuner() from vb2_core_streamon(), I have
> had to this wrapper to maintain the abstraction introduced
> in videobuf2 work.
> 
> Hope this helps the need for this wrapper.


It is clearer now. Please improve the description of the patch
on the next version for us to remember ;)

Regards,
Mauro
> 
> thanks,
> -- Shuah
> >   
> >> + */
> >> +int v4l_vb2q_enable_media_tuner(struct vb2_queue *q)
> >> +{
> >> +	struct v4l2_fh *fh = q->owner;
> >> +
> >> +	return v4l_enable_media_tuner(fh->vdev);
> >> +}
> >> +EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_tuner);
> >> +
> >>  /* Priority handling */
> >>  
> >>  static inline bool prio_is_valid(enum v4l2_priority prio)
> >> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> >> index 68999a3..1948097 100644
> >> --- a/include/media/v4l2-dev.h
> >> +++ b/include/media/v4l2-dev.h
> >> @@ -179,6 +179,7 @@ struct video_device * __must_check video_device_alloc(void);
> >>  
> >>  int v4l_enable_media_tuner(struct video_device *vdev);
> >>  void v4l_disable_media_tuner(struct video_device *vdev);
> >> +int v4l_vb2q_enable_media_tuner(struct vb2_queue *q);  
> > 
> > Documentation?
> >   
> >>  
> >>  /* this release function frees the vdev pointer */
> >>  void video_device_release(struct video_device *vdev);  
> 
> 
