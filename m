Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:49707 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0DDSsp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Apr 2010 14:48:45 -0400
Received: from pcvirus (p5DC8F524.dip.t-dialin.net [93.200.245.36])
	by mis07.de (Postfix) with ESMTPA id 53B47144E02C
	for <linux-media@vger.kernel.org>; Sun,  4 Apr 2010 20:48:42 +0200 (CEST)
Message-ID: <2A74AB3078F34BB484457496310C528B@pcvirus>
From: "rath" <mailings@hardware-datenbank.de>
To: <linux-media@vger.kernel.org>
Subject: update gspca driver in linux source tree
Date: Sun, 4 Apr 2010 20:47:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a 2.6.29 kernel for my embedded ARM system. I need an newer gspca 
driver, so I downloaded the gspca driver from 
http://linuxtv.org/hg/~hgoede/gspca/ an copied the content of the linux 
folder to my 2.6.29 source tree and tried to cross compile it. But I get the 
error "drivers/media/IR/irfunctions.c:27:20: error: compat.h: No such file 
or directory". Where can I find the missing file and where I have to put it 
in my linux tree?

Do you have some other ideas to cross compile the gspca driver?

Regards, Joern 

