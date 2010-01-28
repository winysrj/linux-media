Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55382 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0A1Wfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 17:35:45 -0500
Received: by ewy19 with SMTP id 19so1306756ewy.21
        for <linux-media@vger.kernel.org>; Thu, 28 Jan 2010 14:35:44 -0800 (PST)
Message-ID: <4B62113E.40905@googlemail.com>
Date: Thu, 28 Jan 2010 22:35:42 +0000
From: David Henig <dhhenig@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Make failed - standard ubuntu 9.10
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please can someone assist, not sure what the cause of the below is? This 
is my second attempt to get linux tv to work, I suspect it's a basic 
level error - sorry I'm fairly new to Linux... output below, I'm running 
a fairly standard ubuntu 9.10 setup.

make[1]: Entering directory `/home/david/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.31
File not found: /lib/modules/2.6.31-17-generic/build/.config at 
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** No rule to make target `.myconfig', needed by 
`config-compat.h'. Stop.
make[1]: Leaving directory `/home/david/v4l-dvb/v4l'
make: *** [all] Error 2

