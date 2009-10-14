Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45682 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761737AbZJNNbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 09:31:32 -0400
Received: by ewy4 with SMTP id 4so4415235ewy.37
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 06:30:55 -0700 (PDT)
Message-ID: <4AD5EEA0.2010709@xfce.org>
Date: Wed, 14 Oct 2009 15:30:40 +0000
From: Ali Abdallah <aliov@xfce.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
References: <4ACDF829.3010500@xfce.org>	<37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	<4ACDFED9.30606@xfce.org>	<829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	<4ACE2D5B.4080603@xfce.org>	<829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	<4ACF03BA.4070505@xfce.org>	<829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>	<4ACF714A.2090209@xfce.org>	<829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>	<4AD5D5F2.9080102@xfce.org> <20091014093038.423f3304@pedra.chehab.org>
In-Reply-To: <20091014093038.423f3304@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> have it implemented). This is the case of xc3028, so you'll need to turn off
> signal detection while tuning, and be sure that you're loading the proper frequency
> table used on your Country.
>
>   
> It should be noticed that several tuner drivers don't have signal 
> detection (or not
This is what i'm doing actually, i have signal detection disabled in 
tvtime+of course the proper frequency for my country, but still i get 
channels with very bad pictures (not watchable) with my USB sticks, but 
i get all the channels with a very good pictures with my PCI card (with 
signal detection enabled), and using the same analog cable+same 
setup+same kernel version.

>
> Cheers,
> Mauro
>   

Cheers,
Ali.
