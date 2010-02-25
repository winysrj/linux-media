Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60156 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0BYIOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 03:14:16 -0500
Received: by vws16 with SMTP id 16so465426vws.19
        for <linux-media@vger.kernel.org>; Thu, 25 Feb 2010 00:14:16 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 00:14:15 -0800
Message-ID: <a3ef07921002250014g618908act38d7c3541f33b54d@mail.gmail.com>
Subject: Problem with v4l tree and kernel 2.6.33
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel 2.6.33 just went stable.  I compiled, installed, reboot.
Grabbed a fresh v4l tree, menuconfig'ed, compiled and installed.  Upon
loading I got "Invalid module format" for each file.  For example:
WARNING: Error inserting dvb_ttpci
(/lib/modules/2.6.33.amd64-x2.022410.1/kernel/drivers/media/dvb/ttpci/dvb-ttpci.ko):
Invalid module format

I then did a distclean, make, make install:

Updating/Creating .config
Preparing to compile for kernel version 2.6.33
VIDEO_TVP7002: Requires at least kernel 2.6.34
RADIO_SAA7706H: Requires at least kernel 2.6.34
Created default (all yes) .config file

Again, "Invalid module format".  I then confirmed that .version
matched my 2.6.33 kernel:

test:/v4l-dvb$ cat v4l/.version
VERSION=2
PATCHLEVEL:=6
SUBLEVEL:=33
KERNELRELEASE:=2.6.33.amd64-x2.022410.1
test:/v4l-dvb$ uname -r
2.6.33.amd64-x2.022410.1

So... I'm at a loss why this is happening.  Any ideas?

kernel 2.6.33
gcc (Debian 4.4.2-9) 4.4.3 20100108 (prerelease)
v4l tree 37581bb7e6f1 tip

Thanks in advance.
