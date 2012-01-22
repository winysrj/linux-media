Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-xsmtp4.externet.hu ([212.40.96.155]:56720 "EHLO
	mail-xsmtp4.externet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2AVNKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 08:10:13 -0500
Message-ID: <4F1C0921.1060109@gmail.com>
Date: Sun, 22 Jan 2012 14:03:29 +0100
From: Csillag Kristof <csillag.kristof@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: 720p webcam providing VDPAU-compatible video stream?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linux-media users,

I have stopped following the advancements in Linux video
(and video hw in general) a while ago, so I am no longer
up to date with the current technologies,
therefore I seek your advice.

I am looking for for a webcam that
  - works properly under GNU/Linux (without proprietary drivers)
  - connects via USB 2.0
  - can capture 720p video at 25 or 30 FPS
  - provides a video stream that
    - is hardware compressed by the camera
    - can be recorded to a file with minimal CPU requirements
      (Bonus points if it's wrapped a nice container format,
      so that I can simply record it by something like
      cat /dev/video0 > capture.mpeg
      - like old Hauppauge PVR-250 cards )
    - can be decoded by VDPAU hw acceleration

I have tried to look into this, and it seems that the status for H264
streams for UVC webcams is still problematic.

However, I don't specifically need neither UVC nor H264; any driver,
and any other VDPAU-supported format (like MPEG-2, VC-1, WMV9, etc)
could be OK.

I am not interested in sykpe; I only want to capture the 720p video stream
to files (with as low CPU usage as possible), and play it back
using mplayer, on NVidia cards supporting VDPAU hw acceleration
  - again, with as low CPU usage, as possible.

Could someone please recommend me a device that can do this?
(Or tell me which device will likely get the required support soon?

Thank you for your help:

    Kristof Csillag

