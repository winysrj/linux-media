Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f202.google.com ([209.85.223.202]:56906 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0DZTBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 15:01:54 -0400
Received: by iwn40 with SMTP id 40so3398297iwn.1
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 12:01:54 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Apr 2010 12:01:53 -0700
Message-ID: <l2pb2f477881004261201tf1a12c46w16212f8943d5ae24@mail.gmail.com>
Subject: HDPVR Poor quality S-Video Capture
From: Mark Goldberg <marklgoldberg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the 20100401 snapshot kernel modules from ATrpms on F12, I've
noticed that the quality
of video capture from the HDPVR is significantly worse than that from a PVRUSB2,
using the S-Video input. It is less sharp and has jaggier edges on things like
on screen displays from the video source (sat TV S-video output). This
is with Mythtv
and I've tried various video output settings, ffmpeg and VDPAU
decoding, deinterlacing,
etc. This is with an NTSC 480i input.

Any suggestions would be welcome. I've compiled the modules myself and can make
any changes suggested for troubleshooting. I can also provide sample captures if
needed

Thanks,

Mark
