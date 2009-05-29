Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45815 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZE2OZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 10:25:09 -0400
Received: by ewy24 with SMTP id 24so6303303ewy.37
        for <linux-media@vger.kernel.org>; Fri, 29 May 2009 07:25:09 -0700 (PDT)
Message-ID: <4A1FF043.7080001@gmail.com>
Date: Fri, 29 May 2009 15:25:07 +0100
From: pbflyingdutchman@googlemail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: kernel dvb include files, how do you get them in application path?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I noticed that when installing new linux kernel sources in /usr/src the 
standard include structure in /usr/include is out of 'sync' with the 
kernel structure.
Should the /usr/include/linux dir not be a symbolic link into 
/usr/src/linux/include/linux?
I noticed that when compiling VDR  it was picking up old dvb include 
files from before the DVB-S2 release. So obviously things did not work 
right.

Peter
