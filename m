Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759460AbZJNTvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 15:51:11 -0400
Message-ID: <4AD62B7E.9010606@gmx.de>
Date: Wed, 14 Oct 2009 21:50:22 +0200
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: stv090x/stv6110x improvements and bug fixes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

some time ago, I made some improvements and fixed some bugs in the 
stv090x and stv6110x frontend drivers. These include:

- increased search range on STV090x based on symbol rate
- fixed some STV090x register definitions and typos
- fix STR and SNR calculation and normalize the value into the 0..0xFFFF 
range
- fixed STV6110x r divider calculation when setting frequency
- first disable DVB-S and DVB-S2 mode before enabling it again for 
automatic search
- fix calculation of AGC2 values
- corrections of several register values
- several blind scan related fixes

They were available since about two months and tested successfully using 
TT S2-1600 card by me and other people from vdrportal.de. I made them 
public in my repository available at http://powarman.dyndns.org/hg/v4l-dvb

Regards
Andreas
