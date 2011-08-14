Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1HNGdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 02:33:37 -0400
Received: by yxj19 with SMTP id 19so2725346yxj.19
        for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 23:33:37 -0700 (PDT)
Message-ID: <4E476C3D.7040903@rabbitears.info>
Date: Sun, 14 Aug 2011 02:33:33 -0400
From: Trip Ericson <webmaster@rabbitears.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge Aero-M Driver Problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all:

Since my previous e-mail, I was able to get a Linux driver for the tuner 
from Hauppauge.  It came in the form of a v4l tree with the driver 
included.  I adjusted the v4l/.config file to only build the necessary 
driver.  Once it built and I invoked depmod -a, I hooked in my tuner, it 
detected the tuner, but then dmesg gave me:

[31537.360109] dvb_usb_mxl111sf: probe of 2-1.4:1.0 failed with error -22

Does anyone have any idea what this could be?  I can't find anything 
helpful about error -22 when I go looking.  I can provide the link to 
the driver or output from any command requested, I just need to know 
what to provide and how best to share it.

There was also a driver for the Mobile DTV half of the tuner included, 
but I could not get that part to build successfully, so I abandoned it 
for the time being in favor of getting the regular ATSC part to work.

Thanks for any thoughts or assistance.  It is greatly appreciated. =)

- Trip
www.rabbitears.info
