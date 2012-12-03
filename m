Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm7-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.151]:43259 "EHLO
	nm7-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650Ab2LCKC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Dec 2012 05:02:58 -0500
Message-ID: <1354528977.50830.YahooMailNeo@web160606.mail.bf1.yahoo.com>
Date: Mon, 3 Dec 2012 02:02:57 -0800 (PST)
From: Dmitriy Alekseev <alexeev6@yahoo.com>
Reply-To: Dmitriy Alekseev <alexeev6@yahoo.com>
Subject: How to use multiple video devices simultaneously
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I have a pair of capture dongles Avermedia DVD EZMaker 7 (C039) which have cx231xx chip.
Now using vlc and gst-launch-0.10 I can watch/stream video only from one of them simultaneously.

For example videolan messages I got opening second device: 
[0x7f055c001688] v4l2 demux error:
VIDIOC_QBUF failed libv4l2: error mmapping buffer 0: Device or resource busy
[0x7f055c001688] v4l2 demux error: 
VIDIOC_QBUF failed libv4l2: warning v4l2 mmap buffers still mapped on close() 
[0x7f055c002ec8] v4l2 access error: mmap failed (Device or resource busy) 
[0x7f055c002ec8] v4l2 access error: mmap failed (Device or resource busy) 
[0xb5c698] main input error: open of `v4l2:///dev/video0' failed: (null)

I wonder, what the problem is?
Thank You.

Best regards,
Dmitriy Alekseev 
