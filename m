Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:39738 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0AXIIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 03:08:11 -0500
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id AB8C1E080DC
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 09:08:05 +0100 (CET)
Received: from [192.168.1.2] (lns-bzn-50f-62-147-234-34.adsl.proxad.net [62.147.234.34])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 7750CE08094
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 09:08:02 +0100 (CET)
Message-ID: <4B5BFFE3.30003@free.fr>
Date: Sun, 24 Jan 2010 09:08:03 +0100
From: Chris Moore <moore@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [linux-dvb] Looking for original source of an old DVB tree
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Short version:
I am looking for the original source code of a Linux DVB tree containing 
in particular
     drivers/media/dvb/dibusb/microtune_mt2060.c
and the directory
     drivers/media/dvb/dibusb/mt2060_api

Googling for microtune_mt2060.c and mt2060_api is no help.
Could anyone kindly point me in the right direction, please?

Longer version:
I am trying to get my USB DVB-T stick running on my Xtreamer.
Xtreamer uses an old 2.6.12.6 kernel heavily modified by Realtek and 
possibly also modified by MIPS.
I have the source code but it would be a tremendous effort to change to 
a recent kernel.
The DVB subtree seems to have been dirtily hacked by Realtek to support 
their frontends.
In the process they seem to have lost support for other frontends.
I have been trying to find the source code for the original version.
I have found nothing resembling it in kernel.org, linux-mips.org and 
linuxtv.org.

TIA.

Cheers,
Chris


