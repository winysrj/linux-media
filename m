Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35263 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZH3H3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 03:29:41 -0400
Received: by ewy2 with SMTP id 2so3199524ewy.17
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 00:29:42 -0700 (PDT)
Date: Sun, 30 Aug 2009 09:29:40 +0200
From: tartifola@gmail.com
To: linux-media@vger.kernel.org
Subject: Lenovo compact cam 17ef:4802
Message-Id: <20090830092940.73393e46.tartifola@gmail.com>
Reply-To: tartifola@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,
I'm experiencing problems with a Lenovo compact USB cam. I'm using Gentoo
with kernel 2.6.30-gentoo-r4. I tried to use the built-in modules and
also with gspca-af183a871db8 form linuxTV with the same result. It
seems that the cam is correctly recognized

>dmesg
Linux video capture interface: v2.00
gspca: main v2.6.0 registered
gspca: probing 17ef:4802
vc032x: check sensor header 20
vc032x: Sensor ID 143a (3)
vc032x: Find Sensor MI1310_SOC
gspca: probe ok
usbcore: registered new interface driver vc032x
vc032x: registered

However when I try to use it, for example, with cheese I get this error

>cheese                                          
(cheese:21741): GStreamer-WARNING **: pad source:src returned caps which are not a real subset of its template caps
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error

Essentially Cheese does not show any available resolutions. Problems
also with xawtv

>xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.30-gentoo-r4)
WARNING: v4l-conf is compiled without DGA support.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

and a similar issue with mplayer

Any help to debug my problem?
Thanks in advance

