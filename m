Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17374C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C743220892
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544036207;
	bh=HeyqKBhaW9LBXAu266HjX8uV+t0WeEGgV0edq2ykqxM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=QHmLWFDAOupRYwRK0GyFinFWwP2pIUbH3yQfBuocGEIKJ+ZKkejmF95ZGppUUHLYl
	 U+AqiWbwI0Q1VQbDJBNDILgACcppVVl2TjyJmZU4MN5ea9UkWPDO5gSMM1US1LMiKD
	 2RB/U659AkQHJAsTv6MdemZbTk4uIdQjZhNsSV4g=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C743220892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbeLES4r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:56:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:41684 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLES4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 13:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uurqPfMb0pP0912/H2j2zKPcaevw7NyiBOJK6X9n4vY=; b=bGpnLSqzhd2h416ASdBozfr7Ko
        4cfbyn44babhpLyCYGlCDeH8QatCxI6yjWSFJ1U14yS4+lHben0uHps6fDs93PzZvxgovr62Wy1IN
        zMlfBRTKM+i1pKKk4j0ixEKfuf4ilhvXIY2U1JxyDIgwT0umtR0vL95p6A63YHnu2Jq6plPjBMQyT
        SaBfRIsyYdF6xsimttYuR71muNfa3TNI3t8aYYxskzvl5+qVmz7Dq034CBtQvpmpAr2am3vwYim5P
        tvyZPjEe9yubNvv76gPdaltJCcQ3qzHnPkVzbzsOZLlFRGbL8k4vRQ5XLBzpimHtY+oW2fsTJmqcJ
        /BNu1OHQ==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUcLj-000568-Pt; Wed, 05 Dec 2018 18:56:44 +0000
Date:   Wed, 5 Dec 2018 16:56:39 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Andreas Pape <ap@ca-pape.de>
Cc:     kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] media: stkwebcam: Bugfix for not correctly
 initialized camera
Message-ID: <20181205165639.3464801c@coco.lan>
In-Reply-To: <20181130155807.f1be928e4fc3a05e13fc710b@ca-pape.de>
References: <20181123161454.3215-1-ap@ca-pape.de>
        <20181123161454.3215-3-ap@ca-pape.de>
        <b527358c-8fb9-fbe5-be19-43e8992e85c7@ideasonboard.com>
        <20181130155807.f1be928e4fc3a05e13fc710b@ca-pape.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 30 Nov 2018 15:58:07 +0100
Andreas Pape <ap@ca-pape.de> escreveu:

> Hi Kieran,
> 
> thanks for the review.
> 
> On Mon, 26 Nov 2018 12:48:08 +0000
> Kieran Bingham <kieran.bingham@ideasonboard.com> wrote:
> 
> > This one worries me a little... (but hopefully not too much)
> >  
> 
> As mentioned, I don't have any experience concerning video drivers;-). I found
> this patch more or less experimentally....
>  
> >   
> > > Signed-off-by: Andreas Pape <ap@ca-pape.de>
> > > ---
> > >  drivers/media/usb/stkwebcam/stk-webcam.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> > > index e61427e50525..c64928e36a5a 100644
> > > --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> > > +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> > > @@ -1155,6 +1155,8 @@ static int stk_vidioc_streamon(struct file *filp,
> > >  	if (dev->sio_bufs == NULL)
> > >  		return -EINVAL;
> > >  	dev->sequence = 0;
> > > +	stk_initialise(dev);
> > > +	stk_setup_format(dev);  
> > 
> > Glancing through the code base - this seems to imply to me that s_fmt
> > was not set/called (presumably by cheese) as stk_setup_format() is
> > called only by stk_vidioc_s_fmt_vid_cap() and stk_camera_resume().
> > 
> > Is this an issue?
> > 
> > I presume that this means the camera will just operate in a default
> > configuration until cheese chooses something more specific.
> >  
> 
> Could be. I had a video but colours, sensitivity and possibly other things
> were crap or at least very "psychedelic". Therefore the idea came up that
> some kind of initialisation was missing here. 
> 
> > Actually - looking further this seems to be the case, as the mode is
> > simply stored in dev->vsettings.mode, and so this last setup stage will
> > just ensure the configuration of the hardware matches the driver.
> > 
> > So it seems reasonable to me - but should it be set any earlier?
> > Perhaps not.
> > 
> > 
> > Are there any complaints when running v4l2-compliance on this device node?
> >   
> 
> Here is the output of v4l2-compliance:
> 
> v4l2-compliance SHA   : not available
> 
> Driver Info:
> 	Driver name   : stk
> 	Card type     : stk
> 	Bus info      : usb-0000:00:1d.7-5
> 	Driver version: 4.15.18
> 	Capabilities  : 0x85200001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x05200001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 	test for unlimited opens: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
> 	Control ioctls:
> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> 		test VIDIOC_QUERYCTRL: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 4 Private Controls: 0
> 
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		warn: v4l2-test-formats.cpp(732): TRY_FMT cannot handle an invalid pixelformat.
> 		warn: v4l2-test-formats.cpp(733): This may or may not be a problem. For more information see:
> 		warn: v4l2-test-formats.cpp(734): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> 		test VIDIOC_TRY_FMT: OK
> 		warn: v4l2-test-formats.cpp(997): S_FMT cannot handle an invalid pixelformat.
> 		warn: v4l2-test-formats.cpp(998): This may or may not be a problem. For more information see:
> 		warn: v4l2-test-formats.cpp(999): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 		test Cropping: OK (Not Supported)
> 		test Composing: OK (Not Supported)
> 		test Scaling: OK (Not Supported)
> 
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> 	Buffer ioctls:
> 		warn: v4l2-test-buffers.cpp(538): VIDIOC_CREATE_BUFS not supported
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 7

I'll apply this patch. On those USB cameras, the best is to always
initialize, as we can't ensure that apps will do that.

There are actually some record scripts that just do a cat
at the /dev/video0 device, without issuing any ioctl
(or just doing a minimal set of them, via v4l2-ctl).

Thanks,
Mauro
