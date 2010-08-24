Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33132 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab0HXQfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 12:35:21 -0400
Received: by qwh6 with SMTP id 6so6265664qwh.19
        for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 09:35:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=TXpy8da2KF_1-+B3Wjx4OQK7eH0KkG-+if9mQ@mail.gmail.com>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
	<20100817211027.1ffee6ea@list.ru>
	<AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
	<20100818185354.177c4c07@bk.ru>
	<AANLkTi=TXpy8da2KF_1-+B3Wjx4OQK7eH0KkG-+if9mQ@mail.gmail.com>
Date: Tue, 24 Aug 2010 21:05:20 +0430
Message-ID: <AANLkTimvTUsqDtsyKytktwcAp49xcez71eROKh5BsAt8@mail.gmail.com>
Subject: Re: SkyStar S2 on an embedded Linux
From: Nima Mohammadi <nima.irt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Sorry, my bad!
You were right. The channels on FEC 3/4 and 8PSK modulation can't be
locked. Is there any solution to this problem?
I noticed you've quoted my email on a forum:
http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=16173#post16173

On Wed, Aug 18, 2010 at 11:21 PM, Nima Mohammadi <nima.irt@gmail.com> wrote:
> On Wed, Aug 18, 2010 at 7:23 PM, Goga777 <goga777@bk.ru> wrote:
>>
>> would you re-check please again - have you luck with 8PSK-FEC 3/4 dvb-s2 channels ?
>>
>> Goga
>
> Yes, except MTVNHD and Suisse HD (which use QPSK modulation), almost
> all other HD channels on Hotbird are on 8PSK and I can watch them
> without any problem.
>
> Actually, I managed to solve my problem. I was using a lightweight
> implementation of udev called mdev. Today I tried installing udev on
> my embedded system. And although it works fine now, I prefer to use
> mdev and I'd be more than happy if anyone could point out what the
> problem with mdev is. As the documentation of busybox states, mdev can
> load firmwares from the /lib/firmware/ directory.
>
> -- Nima Mohammadi
>



-- Nima Mohammadi
