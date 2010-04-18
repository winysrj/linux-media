Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57233 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0DRSbI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 14:31:08 -0400
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 383418180EE
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 20:31:00 +0200 (CEST)
Received: from [192.168.0.10] (cot38-1-78-243-40-12.fbx.proxad.net [78.243.40.12])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 3F236818036
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 20:30:58 +0200 (CEST)
Message-ID: <4BCB4FE1.7020808@free.fr>
Date: Sun, 18 Apr 2010 20:30:57 +0200
From: moebius <moebius1@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: terratec grabby sound problem
References: <4B7BB7CF.7000208@free.fr>
In-Reply-To: <4B7BB7CF.7000208@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bonsoir,

I've tried to specify another card (an easy cap), so I do :

rmmod em28xx
modprobe em28xx card=64

In this case, I avoid alsamixer step : I get immediatly the bad sound 
and I just have to shut off and on the terratec grabby in pulseaudio 
control applet to get mplayer working. But no progress with mencoder.

There's really a problem...noone else own a terratec grabby device ?

It's really boring, I have a job to do since a long time nowq, and I 
can't do it ......


cordialement,


Le 17/02/2010 10:33, moebius a écrit :
> Bonjour,
>
> I've bought a terratec grabby device but I've experimented some audio
> problems with it
> I run an ubuntu karmic (9.10) distri and use mplayer/mencoder to see and
> capture vhs pal stuff.
>
> But, If video works with mplayer/mencoder, sound doesn't
> So I run alsamixer -c1 to access grabby capture volume, then when I
> change volume slider a little bit I get an ugly sound very jerky
> Then I go to sound préférences of pulsaudio and swith the grabby device
> to off (éteint in french) andb after to analog input and then I get a
> good sound.
>
> I's very strange because with my old pinnacle dvc100 sound works
> immediatly (but this device seems to have problem because sound move
> time to time to an affect like a flanger and then come normal again ; I
> suspect a hardware problem of the device but I cannot be sure because I
> have no microsoft computer to test it).
>
> I've bought this low-cost terratec grabby to do the job but, finally, I
> experiment another problem....I'm trying to grab my vhs since several
> months and I have still no success !
>
> I cannot try to grab my vhs because,even doing things I've mentionned,
> I'm never sure that it works because mencoder encodes but don't show any
> video or sound during it works.
>
>
> I've seached but found nothing...so I post here.....if someone has an
> idea.....
>
> cordialement,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
