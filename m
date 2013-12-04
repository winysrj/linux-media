Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:52632 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDPGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 10:06:36 -0500
From: "Fry, Ashley (GE Intelligent Platforms)" <ashley.fry@ge.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Get Previous Versions
Date: Wed, 4 Dec 2013 15:04:21 +0000
Message-ID: <5E7BEC406408D249B00BF3A73A0A36DF1072016A@LONURLNA02.e2k.ad.ge.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have discover I can get only old linux-media-2012-06-30.tar.bz2 from http://www.linuxtv.org/downloads/drivers/
but don't understand how I can use them within the current build system.
I firstly I did :-
sudo git clone git://linuxtv.org/media_build.git
then 
sudo ./build 
Stopped that  after it had done the kernel patching, then extracted the new linux-media-2012-06-30.tar.bz2
It fails to builds, the media_build/v4l tree is incompatiable
Whereto I go to get the media_build/v4l portion of the tree with the same date.

The old Mercurial repository http://linuxtv.org/hg/v4l-dvb where you could get a complete tarball has been abandoned !

Need some help please....

Thx.
