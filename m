Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:38038 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbeC0Lxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 07:53:32 -0400
Received: by mail-ua0-f176.google.com with SMTP id q38so2394463uad.5
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 04:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+S3egAvOZa5sGdPfO1YPynF06ydPPZLiftyvC33Lb0_CL=m=A@mail.gmail.com>
References: <CA+S3egAvOZa5sGdPfO1YPynF06ydPPZLiftyvC33Lb0_CL=m=A@mail.gmail.com>
From: P G <zradu1100@gmail.com>
Date: Tue, 27 Mar 2018 14:53:31 +0300
Message-ID: <CA+S3egBhLoH0iR3MSw7b1bXdL+38o5MWi3pe26PDsNUEiSSEMg@mail.gmail.com>
Subject: Re: FM radio (SAA7134)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I do not know if this is the problem but:

   As per V4L2 specifications VIDIOC_S_FREQUENCY ioctl expects tuning
   frequency in units of 62.5 KHz, or if the struct v4l2_tuner or struct
   v4l2_modulator capabilities flag V4L2_TUNER_CAP_LOW is set, in units
   of 62.5 Hz. But FM driver presently handling the frequency in
   units of 1 KHz

   FM driver is not setting V4L2_TUNER_CAP_LOW flag , but its
returning vtun.rangelow
   and vtun.rangehigh ranges in HZ . This needs to be corrected in FM driver.

On Tue, Mar 27, 2018 at 1:52 PM, P G <zradu1100@gmail.com> wrote:
> I have tuner card, with radio tuner.
>
> The modules are loaded fine, no errors in dmesg, but radio is having issues.
> I use radio application from xawtv, and also fm tools, but none of
> them is working properly.
> When i fire up radio, it tunes to 1.04MHZ, and i hear sound noise
> (like when radio isn't tuned). If i tune to another frequency, let's
> say 88.0Mhz, i hear the radio station sound for 1-2 seconds, and then
> the tuner tunes back to 1.04Mhz.
> Same applies for fm tools. I tune with command fm 88.0 on, tuner tunes
> in the apropriate radio station for a few seconds and then it goes
> back to noise.
>
> You can see it here as well:
> Code:
>
> v4l2-ctl -d /dev/radio0 --all
>
> Driver Info (not using libv4l2):
>         Driver name   : saa7134
>         Card type     : ASUSTeK P7131 Hybrid
>         Bus info      : PCI:0000:04:01.0
>         Driver version: 3.13.2
>         Capabilities  : 0x85050015
>                 Video Capture
>                 Video Overlay
>                 VBI Capture
>                 Tuner
>                 Radio
>                 Read/Write
>                 Streaming
>                 Device Capabilities
>         Device Caps   : 0x00050000
>                 Tuner
>                 Radio
> Priority: 2
> Frequency for tuner 0: 16640 (1.040000 MHz)
> Tuner 0:
>         Name                 : Radio
>         Capabilities         : 62.5 Hz stereo freq-bands
>         Frequency range      : 65.000 MHz - 108.000 MHz
>         Signal strength/AFC  : 0%/0
>         Current audio mode   : stereo
>         Available subchannels: mono
>                            mute (bool)   : default=0 value=0
>
> The frequency of the tuner is 1.040000 MHz, but the range of the tuner
> is between 65 and 108 as it should be.
> Does anyone has any idea if is FM driver bug?
