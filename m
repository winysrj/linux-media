Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33161 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab0HRSwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Aug 2010 14:52:03 -0400
Received: by qwh6 with SMTP id 6so827456qwh.19
        for <linux-media@vger.kernel.org>; Wed, 18 Aug 2010 11:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100818185354.177c4c07@bk.ru>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
	<20100817211027.1ffee6ea@list.ru>
	<AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
	<20100818185354.177c4c07@bk.ru>
Date: Wed, 18 Aug 2010 23:21:58 +0430
Message-ID: <AANLkTi=TXpy8da2KF_1-+B3Wjx4OQK7eH0KkG-+if9mQ@mail.gmail.com>
Subject: Re: SkyStar S2 on an embedded Linux
From: Nima Mohammadi <nima.irt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Aug 18, 2010 at 7:23 PM, Goga777 <goga777@bk.ru> wrote:
>
> would you re-check please again - have you luck with 8PSK-FEC 3/4 dvb-s2 channels ?
>
> Goga

Yes, except MTVNHD and Suisse HD (which use QPSK modulation), almost
all other HD channels on Hotbird are on 8PSK and I can watch them
without any problem.

Actually, I managed to solve my problem. I was using a lightweight
implementation of udev called mdev. Today I tried installing udev on
my embedded system. And although it works fine now, I prefer to use
mdev and I'd be more than happy if anyone could point out what the
problem with mdev is. As the documentation of busybox states, mdev can
load firmwares from the /lib/firmware/ directory.

-- Nima Mohammadi
