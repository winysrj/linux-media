Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39309 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0EEHrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 03:47:15 -0400
Received: by gwj19 with SMTP id 19so2050409gwj.19
        for <linux-media@vger.kernel.org>; Wed, 05 May 2010 00:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100505172759.6da65251@glory.loctelecom.ru>
References: <20100505145027.1571f12c@glory.loctelecom.ru>
	 <u2y6e8e83e21005042244g2ba765c9ga1822df8093baae@mail.gmail.com>
	 <20100505172759.6da65251@glory.loctelecom.ru>
Date: Wed, 5 May 2010 15:47:13 +0800
Message-ID: <n2l6e8e83e21005050047mdf62405dz48653d44b2a5eb81@mail.gmail.com>
Subject: Re: tm6000
From: Bee Hock Goh <beehock@gmail.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you do that you will get some decent looking video.

On Wed, May 5, 2010 at 3:27 PM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> On Wed, 5 May 2010 13:44:38 +0800
> Bee Hock Goh <beehock@gmail.com> wrote:
>
>> Did you comment off the code in the get_next_buff that clear the
>> previous frame data?
>
> No.
>
> Git tree + my last patch.
>
> With my best regards, Dmitry.
>
>> On Wed, May 5, 2010 at 12:50 PM, Dmitri Belimov <d.belimov@gmail.com>
>> wrote:
>> > Hi
>> >
>> > At this moment I can start mplayer and see green field with some
>> > junk without crash. Info from mplayer - received 497 frames, drop
>> > 69 incorrect frames.
>> >
>> > Compile without support DVB-T for our cards.
>> >
>> > Now try understand init process working drivers and diff with linux.
>> >
>> > P.S. Linux kernel is 2.6.33
>> >
>> > With my best regards, Dmitry.
>> >
>
