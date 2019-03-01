Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D43CC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CADC22084D
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551447347;
	bh=EkKn8mwGkJ1WjC7Oxpbj65a+ShisH6K63qM8P2VE+Q4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=zulpRdekx4tIK0UavAkeysDXFN1LbbaQQmgdn2dy6P1x3mXzLtgnt1Ri0248Ix4/M
	 y8LfkGV9wIuqqBl8h6Glo2thjIDA5xqbUT4XeR/3L0VJ1fCRNxzq9u15vfHpL/HEPJ
	 andvjwPoGA5fkApMIs9zlhptiC0UboT1JBZXF5+g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbfCANfr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:35:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387821AbfCANfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GlVjecXc6yGagJQWH7Od0HCAyc/MmTv1Kfa7Hnr7oqM=; b=iVPmJoYbz1s1UTNmFpgjpZhVk
        qxg/iTb79wDKzZZImAY0n5QyJUgrYgulddQK3EYkkjcIOhzvKSSVlaxee0ZCiyawRe5naSWZH5xeW
        DZhNqm++IYh3q4k+7IFCMhSalh0UwAex90NYdIgh7HS9yDf29Wkt6bqyto+5fKCc7SRNV/1MyQWbo
        CrIIuOtFBLswvzCIv8fFNPQ9v6QmrcASU4xBEZeVH6Cbq+WYOHpQSFQizumhODERo33K+zeYvk0j8
        QlKqqpovqemZF46RDl67sW6Et+8xvpFD/0Sml1menMvsgjG3hXbjRk1J1kuLodmvtP0StDuWTqUnN
        u8T1qrqkQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gziKH-00031y-T5; Fri, 01 Mar 2019 13:35:46 +0000
Date:   Fri, 1 Mar 2019 10:35:42 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 00/10] Improvements and fixups for vim2m driver
Message-ID: <20190301103542.0c4f7ed0@coco.lan>
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri,  1 Mar 2019 10:24:16 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> The vim2m was laking care for a long time. It had several issues. Several
> were already fixed and are merged for Kernel 5.1, but there are still
> some pending things.
> 
> This patch series complement the work, making it do the right thing with
> regards to different resolutions at capture and output buffers.
> 
> Although it contains some improvements (like the addition of Bayer),
> I'm tempted to do a late merge for it, in order for the entire set of changes
> to go to Kernel 5.1, specially since:
> 
> a) It contains a fix at the buffer filling routine. At least this one should
> go to 5.1 anyway;
> 
> b) while the other patches could eventually go to 5.2, they also do 
> significant changes at the buffer handling logic;
> 
> c) It disables YUYV as output format (due to the horizontal scaler). It
> would be good that such change would go together with the changes for
> 5.1 with actually implements YUYV support;
> 
> d) This is a test driver anyway and shouldn't affect systems in production.
> 
> e) As we're using it also to properly implement/fix Bayer support for M2M
> transform drivers at Gstreamer, it would be better to have everything
> altogether.
> 
> So, if nobody complains, I'll likely merge this series later today or along the
> weekend for Kernel 5.1.

As requested on IRC, those are the results for the regression test:

#./test-media vim2m
Video input set to 3 (HDMI 0: Camera, ok)
Output set to 1
Video input set to 3 (HDMI 0: Camera, ok)
Output set to 1
Video input set to 3 (HDMI 0: Camera, ok)
Output set to 1


vim2m compliance tests

sex mar  1 10:33:00 -03 2019
v4l2-compliance SHA: 70d543c3ec02698d63f0de97397566651f9d3aa2, 64 bits

Compliance test for vim2m device /dev/media0:

Media Driver Info:
	Driver name      : vim2m
	Model            : vim2m
	Serial           : 
	Bus info         : platform:vim2m
	Media version    : 5.0.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 5.0.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

Total for vim2m device /dev/media0: 7, Succeeded: 7, Failed: 0, Warnings: 0
--------------------------------------------------------------------------------
Compliance test for vim2m device /dev/video0:

Driver Info:
	Driver name      : vim2m
	Card type        : vim2m
	Bus info         : platform:vim2m
	Driver version   : 5.0.0
	Capabilities     : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : vim2m
	Model            : vim2m
	Serial           : 
	Bus info         : platform:vim2m
	Media version    : 5.0.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 5.0.0
Interface Info:
	ID               : 0x0300000c
	Type             : V4L Video
Entity Info:
	ID               : 0x00000001 (1)
	Name             : vim2m-source
	Function         : V4L2 I/O
	Pad 0x01000002   : 0: Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'vim2m-proc': Data, Enabled, Immutable

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 3 Private Controls: 2

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK
	test Requests: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK (Not Supported)
	test blocking wait: OK
	Video Capture: Captured 10 buffers
	test MMAP (no poll): OK
	Video Capture: Captured 10 buffers
	test MMAP (select): OK
	Video Capture: Captured 10 buffers
	test MMAP (epoll): OK
	Video Capture: Captured 10 buffers
	test USERPTR (no poll): OK
	Video Capture: Captured 10 buffers
	test USERPTR (select): OK
	Video Capture: Captured 10 buffers
	test DMABUF (no poll): OK
	Video Capture: Captured 10 buffers
	test DMABUF (select): OK

Total for vim2m device /dev/video0: 54, Succeeded: 54, Failed: 0, Warnings: 0

Grand Total for vim2m device /dev/media0: 61, Succeeded: 61, Failed: 0, Warnings: 0









unbind vim2m


rebind vim2m


second unbind vim2m


rmmod vim2m









sex mar  1 10:33:09 -03 2019

unbind vivid


rmmod vivid

sex mar  1 10:33:12 -03 2019

Summary:

Total for vim2m device /dev/media0: 7, Succeeded: 7, Failed: 0, Warnings: 0
Total for vim2m device /dev/video0: 54, Succeeded: 54, Failed: 0, Warnings: 0
Grand Total for vim2m device /dev/media0: 61, Succeeded: 61, Failed: 0, Warnings: 0

Final Summary: 61, Succeeded: 61, Failed: 0, Warnings: 0
sex mar  1 10:33:12 -03 2019


Thanks,
Mauro
