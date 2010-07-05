Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54603 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0GEVkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 17:40:39 -0400
Received: by gye5 with SMTP id 5so1423953gye.19
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 14:40:38 -0700 (PDT)
MIME-Version: 1.0
From: Kyle Baker <kyleabaker@gmail.com>
Date: Mon, 5 Jul 2010 17:40:18 -0400
Message-ID: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
Subject: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm testing the VX-1000 model web cam in test builds of Ubuntu 10.10
x86_64 and have found that the gspca drivers allow the microphone to
work with a sound recorder initially. However, when I test sound and
video together with Cheese, the microphone no longer works and doesn't
work again on the computer until the web cam is detached and
reattached.

I was able to track the events in the system logs as follows:

Jul 5 16:49:52 kyleabaker-desktop kernel: [104818.122525] usb 2-1: new
full speed USB device using ohci_hcd and address 5
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.349087] gspca:
probing 045e:00f7
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.361046] sonixj:
Sonix chip id: 11
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.367105] input:
sonixj as /devices/pci0000:00/0000:00:02.0/usb2/2-1/input/input5
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.367172] gspca: video0 created
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.367174] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100
Jul 5 16:49:53 kyleabaker-desktop kernel: [104818.367235] gspca:
probing 045e:00f7
Jul 5 16:53:35 kyleabaker-desktop kernel: [105040.981955] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100
Jul 5 16:53:37 kyleabaker-desktop kernel: [105042.537923] ohci_hcd
0000:00:02.0: leak ed ffff88003796e370 (#81) state 2
Jul 5 16:53:37 kyleabaker-desktop kernel: [105042.537957] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100
Jul 5 16:53:37 kyleabaker-desktop kernel: [105042.537960] gspca:
bandwidth not wide enough - trying again
Jul 5 16:53:37 kyleabaker-desktop kernel: [105042.564943] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100
Jul 5 16:54:08 kyleabaker-desktop kernel: [105073.800352] gspca: found
int in endpoint: 0x83, buffer_len=1, interval=100

I opened Cheese to test sound and video at the 16:53 point. This seems
to be unique to x86_64 systems as I'm getting reports that 32-bit
users are not having any problems with this, but I don't have a 32-bit
install to test myself.

The selected input microphone remains the one in the web cam, but the
drivers fail or break when it is started with video.

--
Kyle Baker
