Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:61456 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZAMXCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 18:02:14 -0500
Received: by qyk4 with SMTP id 4so349641qyk.13
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2009 15:02:12 -0800 (PST)
Message-ID: <412bdbff0901131502g12d62917ka4fbebf7b74c6579@mail.gmail.com>
Date: Tue, 13 Jan 2009 18:02:12 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Bastian Beekes" <bastian.beekes@gmx.de>
Subject: Re: MSI DigiVox A/D II
Cc: linux-media@vger.kernel.org
In-Reply-To: <496D1C18.3010403@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>
	 <496D1C18.3010403@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 13, 2009 at 5:56 PM, Bastian Beekes <bastian.beekes@gmx.de> wrote:
> Hi everybody,
>
> I got a MSI DigiVox A/D II and am running Ubuntu 8.04.
> I got picture working with the drivers from http://linuxtv.org/hg/v4l-dvb
>  , but I don't have sound.
>
> This device already worked with the em28xx-drivers from mcentral.de, but I
> had to manually load snd-usb-audio and em28xx-audio. The problem is, I don't
> have the em28xx-audio module.
> I see a souce-file in /v4l-dvb/linux/drivers/media/video/em28xx for
> em28xx-audio, so how do I build it?
>
> btw, my usb-id is eb1a:e323, so it is recognized as Kworld VS-DVB-T 323UR ,
> but it in fact is a MSI DigiVox A/D II...
>
> thanks for your help,
> Bastian

Ubuntu screwed up their build process in 8.04 so that none of the
v4l-dvb "-audio" modules would get built.  The issue was fixed in
8.10.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
