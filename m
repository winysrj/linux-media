Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0EEFoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 01:44:39 -0400
Received: by gyg13 with SMTP id 13so2021544gyg.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 22:44:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100505145027.1571f12c@glory.loctelecom.ru>
References: <20100505145027.1571f12c@glory.loctelecom.ru>
Date: Wed, 5 May 2010 13:44:38 +0800
Message-ID: <u2y6e8e83e21005042244g2ba765c9ga1822df8093baae@mail.gmail.com>
Subject: Re: tm6000
From: Bee Hock Goh <beehock@gmail.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Did you comment off the code in the get_next_buff that clear the
previous frame data?

On Wed, May 5, 2010 at 12:50 PM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> At this moment I can start mplayer and see green field with some junk without crash.
> Info from mplayer - received 497 frames, drop 69 incorrect frames.
>
> Compile without support DVB-T for our cards.
>
> Now try understand init process working drivers and diff with linux.
>
> P.S. Linux kernel is 2.6.33
>
> With my best regards, Dmitry.
>
