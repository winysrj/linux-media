Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:42548 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbeCMP02 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 11:26:28 -0400
Received: by mail-pl0-f46.google.com with SMTP id w15-v6so2372977plq.9
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 08:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f984cfec-80a5-874f-16cb-0939d891863f@st.com>
References: <1520782481-13558-1-git-send-email-akinobu.mita@gmail.com> <f984cfec-80a5-874f-16cb-0939d891863f@st.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 14 Mar 2018 00:26:07 +0900
Message-ID: <CAC5umygoOh7mSTMjaJDTMOtaTfHL9HTsfNnEQHK1BSsFfATzsQ@mail.gmail.com>
Subject: Re: [PATCH] media: ov5640: add missing output pixel format setting
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-03-13 1:18 GMT+09:00 Hugues FRUCHET <hugues.fruchet@st.com>:
> Hi Akinobu,
>
> Thanks for the patch, could you describe the test you made to reproduce
> the issue that I can test on my side ?
>
> I'm using usually yavta or Gstreamer, but I don't know how to trig the
> power on/off independently of streamon/off.

Capturing a single image by yavta and gstreamer can reproduce this issue
in my environment.  I use Xilinx Video IP driver for video device with
the following change in order to support pipeline power management.

https://patchwork.linuxtv.org/patch/46343/

With this change, when opening the video device, s_power() is called with
on=1 for subdevice.

I observed the following steps when capturing a single image by
'yavta -n1 -c1 -Ftest.raw /dev/video1'. (The output pixel format is
already set up by media-ctl before this run)

1. open /dev/video1
2. ov5640_s_power() is called with on=1
   (ov5640_s_power -> ov5640_set_power -> ov5640_restore_mode
    -> ov5640_set_mode, and pending_mode_change is cleared)
3. ov5640_s_stream() is called with on=1
   (But ov5640_set_framefmt() is not called because pending_mode_change
    has already been cleared  in step 2.)

As ov5640_set_framefmt() is not called, output pixel format cannot be
restored (OV5640_REG_FORMAT_CONTROL00 and OV5640_REG_ISP_FORMAT_MUX_CTRL).
