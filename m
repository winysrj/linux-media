Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:46033 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZBOUQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 15:16:09 -0500
Received: by bwz5 with SMTP id 5so2716840bwz.13
        for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 12:16:06 -0800 (PST)
From: Michele <aspeltami@gmail.com>
To: linux-media@vger.kernel.org
Subject: firmware
Date: Sun, 15 Feb 2009 21:15:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902152115.58993.aspeltami@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm new here and i'm trying TM6061 driver from your repo. Actually I'm now 
able to make the module tm6000 and I find my card (wintv-hvr-900h) as card 9.
But when today for the first time my gentoo system recognize it I discovered 
that I need a firmware called "xc3028L-v36.fw".
 I searched a while over the net and it seems to be in vendor CD but it isn't, 
even downloading drivers from webpage I find a sys file but it is not 
tridvid.sys, it is called hcw66xxx.sys (and also it seems to be a 64bit 
version called  hcw66x64.sys). I tried both of them but nothing happend, I 
also try to find that file over internet but everytime file checks fail. 
Someone have some suggestion about where to find it?

Thanks
Michele
