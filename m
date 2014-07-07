Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64761 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaGGR6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 13:58:47 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so5747891pdi.32
        for <linux-media@vger.kernel.org>; Mon, 07 Jul 2014 10:58:47 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 14:58:47 -0300
Message-ID: <CAB0d6EdzyiGFKbjPS4QSwLOvBaWaoRG43K=bwwKVLXyVHYZEmg@mail.gmail.com>
Subject: New v4l2 driver does not allow brightness/contrast control
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a v4l2 video capture board that using kernel 2.6 with v4l2
em28xx driver 3.0.36 allows me to control brightness, contrast etc...
However in kernel 3.2 with v4l2 em28xx driver version 3.2.0 it does not.

This is what I get from the latest driver:
root@android:/ # v4l2-ctl --info
Driver Info (not using libv4l2):
Driver name   : em28xx
Card type     : EM2860/SAA711X Reference Design
Bus info      : usb-musb-hdrc.1-1
Driver version: 3.2.0
Capabilities  : 0x05020051
Video Capture
VBI Capture
Sliced VBI Capture
Audio
Read/Write
Streaming
root@android:/ # v4l2-ctl  -d 0 -l
                         volume (int)    : min=0 max=31 step=1
default=31 value=31 flags=slider
                           mute (bool)   : default=1 value=1


What could be wrong?

-- 
Atenciosamente,
Coutinho
