Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell0.rawbw.com ([198.144.192.45]:59793 "EHLO shell0.rawbw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934474Ab0GOTgP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 15:36:15 -0400
Received: from eagle.syrec.org (stunnel@localhost [127.0.0.1])
	(authenticated bits=0)
	by shell0.rawbw.com (8.14.4/8.14.4) with ESMTP id o6FJU567011749
	for <linux-media@vger.kernel.org>; Thu, 15 Jul 2010 12:30:09 -0700 (PDT)
	(envelope-from yuri@rawbw.com)
Message-ID: <4C3F61BD.7000001@rawbw.com>
Date: Thu, 15 Jul 2010 12:30:05 -0700
From: Yuri <yuri@rawbw.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bugreport for libv4l: error out on webcam: error parsing JPEG header:
 Bogus jpeg format
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I use Logitech QuickCam Deluxe on FreeBSD-8.1.

It shows the image for a while but after 20sec-5min it errors out with 
the message from libv4l, see below.

Could this be a bug in libv4l or it maybe it should be passed some 
tolerance to errors option?

--- log ---
 > pwcview -s vga
Webcam set to: 640x480 (vga) at 5 fps
libv4l2: error converting / decoding frame data: v4l-convert: error 
parsing JPEG header: Bogus jpeg format


Error reading from webcam: Input/output error
