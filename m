Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:50219 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3DQG5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 02:57:23 -0400
Received: by mail-ve0-f178.google.com with SMTP id c13so1141995vea.23
        for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 23:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51688A85.8080206@gmail.com>
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
	<1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com>
	<51688A85.8080206@gmail.com>
Date: Wed, 17 Apr 2013 14:57:22 +0800
Message-ID: <CAHG8p1Dc4erTTQRD5mzZQDsS=Zp_1L7yGkxspAT_T4gPUnBptg@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester ,

>> @@ -9,7 +9,18 @@ config VIDEO_BLACKFIN_CAPTURE
>>           To compile this driver as a module, choose M here: the
>>           module will be called bfin_capture.
>>
>> +config VIDEO_BLACKFIN_DISPLAY
>> +       tristate "Blackfin Video Display Driver"
>> +       depends on VIDEO_V4L2&&  BLACKFIN&&  I2C
>> +       select VIDEOBUF2_DMA_CONTIG
>> +       help
>> +         V4L2 bridge driver for Blackfin video display device.
>
>
> Shouldn't it just be "V4L2 output driver", why are you calling it "bridge" ?
>
Hmm, capture<->display, input<->output, right?
The kernel docs called it bridge, may "host" sounds better.

>> +/*
>> + * Analog Devices video display driver
>
>
> Sounds a bit too generic.
>
>> + *
>> + * Copyright (c) 2011 Analog Devices Inc.
>
>
> 2011 - 2013 ?
>
Written in 2011.

>> +struct disp_fh {
>> +       struct v4l2_fh fh;
>> +       /* indicates whether this file handle is doing IO */
>> +       bool io_allowed;
>> +};
>
>
> This structure should not be needed when you use the vb2 helpers. Please see
> below for more details.
>
The only question is how the core deal with the permission that which
file handle can
stream off the output. I want to impose a rule that only IO handle can stop IO.
I refer to priority, but current kernel driver export this to user
space and let user decide it.
