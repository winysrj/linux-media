Return-path: <mchehab@gaivota>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:60100 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab1EHNQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 09:16:08 -0400
Message-ID: <4DC69795.4010502@arcor.de>
Date: Sun, 08 May 2011 15:16:05 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: tm6000: video buffer
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

I have a few little problems.

1. How I can set up buffer field?
      - Alternate
      - Top
      - Bottom
etc.

2. How I can add time code to buffer?
PTS packet send an 32 bit long frame number, that count edge half frame.

3. How I can set up aspect ratio?
      - 4:3
     - 16:9
incl. after a vbi packet with radio info (WSS)

a few variables which help us:

in structure "tm6000_core" :
aspect
framecount

Stefan Ringel

