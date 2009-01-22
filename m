Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:61286 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZAVVni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 16:43:38 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2030125qwe.37
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 13:43:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901221635550.8219@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>
	 <alpine.LFD.2.00.0901221434040.7609@tupari.net>
	 <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
	 <alpine.LFD.2.00.0901221542190.7960@tupari.net>
	 <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com>
	 <alpine.LFD.2.00.0901221635550.8219@tupari.net>
Date: Thu, 22 Jan 2009 16:43:37 -0500
Message-ID: <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com>
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Joseph Shraibman <linuxtv.org@jks.tupari.net>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2009 at 4:37 PM, Joseph Shraibman
<linuxtv.org@jks.tupari.net> wrote:
>> On some demods, the strength and SNR indicators are only valid if you
>> have a lock.
>
> But why don't I get a lock?  I was getting signals with my pcHDTV3000 so I
> know it isn't an antenna problem.

I just looked back at your dmesg output, and I am somewhat confused.
Do you have multiple cards installed in the host at the same time?
Isn't the Oren OR51132 the other card?  I would assume that you would
need to be looking at the output of the s5h1411 frontend with femon if
you're trying to capture on the Fusion HDTV 7 Dual Express.  Or
perhaps I am just missing something here.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
