Return-path: <linux-media-owner@vger.kernel.org>
Received: from williams.wu-wien.ac.at ([137.208.8.38]:47970 "EHLO
	williams.wu-wien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZC2QBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 12:01:18 -0400
Received: from jo.lan ([195.16.255.206])
	(authenticated bits=0)
	by williams.wu-wien.ac.at (8.13.8/8.13.8/Debian-3) with ESMTP id n2TFp4r3002704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 17:51:05 +0200
From: Johannes Fichtinger <lists@fichtinger.org>
To: linux-media@vger.kernel.org
Subject: Compilation w/ on Kernel 2.6.29 on Debian SID
Date: Sun, 29 Mar 2009 17:50:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291750.58954.lists@fichtinger.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

on my debian SID system using the new kernel 2.6.29-1-686 with both 
linux-headers-2.6.29-1-686 and linux-headers-2.6.29-1-common installed, a 
root@jo:/usr/src/v4l-dvb# make

on the v4l code downloaded this morning results in a compilation error:

---------------------------
make -C /usr/src/v4l-dvb/v4l
make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
perl 
scripts/make_config_compat.pl /lib/modules/2.6.29-1-686/build ./.myconfig ./config-compat.h
File not found: /lib/modules/2.6.29-1-686/build/include/linux/netdevice.h at 
scripts/make_config_compat.pl line 15.
make[1]: *** [config-compat.h] Error 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Error 2
root@jo:/usr/src/v4l-dvb#     
---------------------------

The problem sounds to me related to Debian Bug #521515[1], so I am not sure at 
all if this is a Debian or v4l issue. Any ideas how to get the v4l compiled 
with the new 2.6.29 kernel in Debian?

Best,
Johannes




[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=+Bug%23521515%3A
