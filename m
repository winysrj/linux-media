Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3557EC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF0520854
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfAXHsr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 02:48:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:21794 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbfAXHsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 02:48:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2019 23:48:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,515,1539673200"; 
   d="scan'208";a="140871042"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jan 2019 23:48:44 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 412EE203F6; Thu, 24 Jan 2019 09:48:43 +0200 (EET)
Date:   Thu, 24 Jan 2019 09:48:43 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     xinwu <xinwu.liu@intel.com>
Cc:     mchehab@kernel.org, hans.verkuil@cisco.com,
        niklas.soderlund+renesas@ragnatech.se, ezequiel@collabora.com,
        sque@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-core: expose the device after it was
 registered.
Message-ID: <20190124074842.eumz32b7yegtxccy@paasikivi.fi.intel.com>
References: <1548146084-20445-1-git-send-email-xinwu.liu@intel.com>
 <20190122100311.isx57iktfpxawxjv@paasikivi.fi.intel.com>
 <85906cb2-5472-2c54-e854-136cba8e8d40@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85906cb2-5472-2c54-e854-136cba8e8d40@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 24, 2019 at 03:11:53PM +0800, xinwu wrote:
> Hi Sakari,
> 
> Thanks for your response.
> 
> 
> On 2019年01月22日 18:03, Sakari Ailus wrote:
> > Hi Xinwu,
> > 
> > On Tue, Jan 22, 2019 at 04:34:44PM +0800, Liu, Xinwu wrote:
> > > device_register exposes the device to userspace.
> > > 
> > > Therefore, while the register process is ongoing, the userspace program
> > > will fail to open the device (ENODEV will be set to errno currently).
> > > The program in userspace must re-open the device to cover this case.
> > > 
> > > It is more reasonable to expose the device after everythings ready.
> > > 
> > > Signed-off-by: Liu, Xinwu <xinwu.liu@intel.com>
> > > ---
> > >   drivers/media/v4l2-core/v4l2-dev.c | 14 ++++++++------
> > >   1 file changed, 8 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > > index d7528f8..01e5cc9 100644
> > > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > > @@ -993,16 +993,11 @@ int __video_register_device(struct video_device *vdev,
> > >   		goto cleanup;
> > >   	}
> > > -	/* Part 4: register the device with sysfs */
> > > +	/* Part 4: Prepare to register the device */
> > >   	vdev->dev.class = &video_class;
> > >   	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
> > >   	vdev->dev.parent = vdev->dev_parent;
> > >   	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
> > > -	ret = device_register(&vdev->dev);
> > > -	if (ret < 0) {
> > > -		pr_err("%s: device_register failed\n", __func__);
> > > -		goto cleanup;
> > > -	}
> > >   	/* Register the release callback that will be called when the last
> > >   	   reference to the device goes away. */
> > >   	vdev->dev.release = v4l2_device_release;
> > > @@ -1020,6 +1015,13 @@ int __video_register_device(struct video_device *vdev,
> > >   	/* Part 6: Activate this minor. The char device can now be used. */
> > >   	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
> > > +	/* Part 7: Register the device with sysfs */
> > > +	ret = device_register(&vdev->dev);
> > > +	if (ret < 0) {
> > > +		pr_err("%s: device_register failed\n", __func__);
> > > +		goto cleanup;
> > The error handling needs to reflect the change as well.
> 
> Yes, I think it need to clear the V4L2_FL_REGISTERED also.
> > 
> > Speaking of which, the error handling appears to be somewhat broken here.
> > It should be fixed first before making changes to the registration order.
> 
> I guess you mean to call "put_device()" in this error handling.

No, error handling is broken even without this patch: the return value from
video_register_media_controller() is ignored, for instance.

> > 
> > The problem the patch addresses is related to another problem: how to tell
> > the user space all devices in the media hardware complex have been
> > registered successfully. Order generally has been the node first, and only
> > then the entity. That suggests the order should probably be:
> > 
> > 1. video_register_media_controller
> > 2. set_bit(V4L2_FL_REGISTERED)
> > 3. device_register
> > 
> > I wonder what Hans thinks.
> 
> Yes, that's my suggestion, thanks for the highlight. I also want to know if
> it's worth to make this change.
> > 
> > > +	}
> > > +
> > >   	return 0;
> > >   cleanup:
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
