Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55335 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0JGOaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 10:30:20 -0400
Received: by ewy23 with SMTP id 23so344636ewy.19
        for <linux-media@vger.kernel.org>; Thu, 07 Oct 2010 07:30:19 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Samsung S2 Tuner(DNBU10711IST) Driver
Date: Thu, 7 Oct 2010 17:30:26 +0300
References: <20100921045313.26772.qmail@f5mail-237-214.rediffmail.com>
In-Reply-To: <20100921045313.26772.qmail@f5mail-237-214.rediffmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010071730.26450.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 21 сентября 2010 07:53:13 автор Bala Subramaniam написал:
> Hello all,
> 
> 
> 
> I am making the driver for Samsung S2 Tuner(DNBU10711IST),which has
> stv0903b link chip with front end stv6110 Rf chip.
Yet another stv0903 driver? There is a couple already existed.

> 
> 
> 
> I have implemented the initialize routine and search algorithm with
> 
> help of ST's reference code.
> 
> 
> 
> In case of DVB-S, it works well but DVB-S2 has some problem on
> 
> checking the lock.
> 
> 
> 
> I would like to to get some help what is wrong.
> 
> Or any experience on this is welcome.
> 
> 
> 
> Regards,
> 
> Bala

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
