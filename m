Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51833 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752508AbZAMW4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 17:56:18 -0500
Message-ID: <496D1C18.3010403@gmx.de>
Date: Tue, 13 Jan 2009 23:56:24 +0100
From: Bastian Beekes <bastian.beekes@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MSI DigiVox A/D II
References: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>
In-Reply-To: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I got a MSI DigiVox A/D II and am running Ubuntu 8.04.
I got picture working with the drivers from http://linuxtv.org/hg/v4l-dvb
  , but I don't have sound.

This device already worked with the em28xx-drivers from mcentral.de, but 
I had to manually load snd-usb-audio and em28xx-audio. The problem is, I 
don't have the em28xx-audio module.
I see a souce-file in /v4l-dvb/linux/drivers/media/video/em28xx for 
em28xx-audio, so how do I build it?

btw, my usb-id is eb1a:e323, so it is recognized as Kworld VS-DVB-T 
323UR , but it in fact is a MSI DigiVox A/D II...

thanks for your help,
Bastian
