Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48307 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab0GHTwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 15:52:17 -0400
Received: by iwn7 with SMTP id 7so1226862iwn.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 12:52:16 -0700 (PDT)
Message-ID: <4C362C6E.5050104@gmail.com>
Date: Thu, 08 Jul 2010 15:52:14 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com> <AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>
In-Reply-To: <AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2010 01:52 PM, Devin Heitmueller wrote:
> The vertical stripes were a problem with the anti-alias filter
> configuration, which I fixed a few months ago (and probably just
> hasn't made it into your distribution).  Just install the current
> v4l-dvb code and it should go away:
>
> http://linuxtv.org/repo

Yep, that gets rid of the vertical stripes but adds in a lovely 
horizontal shift:

http://www3.picturepush.com/photo/a/3763906/img/3763906.png

Also, vertical lines look slightly more ragged than they did before, to 
my eye at least.

I'm also encountering this old compilation problem:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg06865.html

I worked around it by disabling firedtv in v4l/.config. (I'm running 
2.6.32-23-generic on Ubuntu Lucid.)

Ivan
