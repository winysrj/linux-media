Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34643 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaGHSJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 14:09:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so1473024wib.0
        for <linux-media@vger.kernel.org>; Tue, 08 Jul 2014 11:09:50 -0700 (PDT)
Message-ID: <53BC342B.4070801@googlemail.com>
Date: Tue, 08 Jul 2014 20:10:51 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Rafael Coutinho <rafael.coutinho@phiinnovations.com>,
	linux-media@vger.kernel.org
Subject: Re: New v4l2 driver does not allow brightness/contrast control
References: <CAB0d6EdzyiGFKbjPS4QSwLOvBaWaoRG43K=bwwKVLXyVHYZEmg@mail.gmail.com>
In-Reply-To: <CAB0d6EdzyiGFKbjPS4QSwLOvBaWaoRG43K=bwwKVLXyVHYZEmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 07.07.2014 19:58, schrieb Rafael Coutinho:
> I have a v4l2 video capture board that using kernel 2.6 with v4l2
> em28xx driver 3.0.36 allows me to control brightness, contrast etc...
> However in kernel 3.2 with v4l2 em28xx driver version 3.2.0 it does not.
>
> This is what I get from the latest driver:
> root@android:/ # v4l2-ctl --info
> Driver Info (not using libv4l2):
> Driver name   : em28xx
> Card type     : EM2860/SAA711X Reference Design
> Bus info      : usb-musb-hdrc.1-1
> Driver version: 3.2.0
> Capabilities  : 0x05020051
> Video Capture
> VBI Capture
> Sliced VBI Capture
> Audio
> Read/Write
> Streaming
> root@android:/ # v4l2-ctl  -d 0 -l
>                          volume (int)    : min=0 max=31 step=1
> default=31 value=31 flags=slider
>                            mute (bool)   : default=1 value=1
>
>
> What could be wrong?

Before kernel 3.10, the brightness (contrast, ...) controls are provided
by the subdevice drivers.
With kernel 3.10 I have introduced bridge level image controls, but they
are currently only used/activated if the subdevice doesn't already
provide them (as suggested by Mauro).

Hth,
Frank Schäfer

