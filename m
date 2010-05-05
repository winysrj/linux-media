Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:59027 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0EEHYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 03:24:51 -0400
Received: by bwz25 with SMTP id 25so2721549bwz.28
        for <linux-media@vger.kernel.org>; Wed, 05 May 2010 00:24:50 -0700 (PDT)
Date: Wed, 5 May 2010 17:27:59 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Bee Hock Goh <beehock@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: Re: tm6000
Message-ID: <20100505172759.6da65251@glory.loctelecom.ru>
In-Reply-To: <u2y6e8e83e21005042244g2ba765c9ga1822df8093baae@mail.gmail.com>
References: <20100505145027.1571f12c@glory.loctelecom.ru>
	<u2y6e8e83e21005042244g2ba765c9ga1822df8093baae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 May 2010 13:44:38 +0800
Bee Hock Goh <beehock@gmail.com> wrote:

> Did you comment off the code in the get_next_buff that clear the
> previous frame data?

No. 

Git tree + my last patch.

With my best regards, Dmitry.

> On Wed, May 5, 2010 at 12:50 PM, Dmitri Belimov <d.belimov@gmail.com>
> wrote:
> > Hi
> >
> > At this moment I can start mplayer and see green field with some
> > junk without crash. Info from mplayer - received 497 frames, drop
> > 69 incorrect frames.
> >
> > Compile without support DVB-T for our cards.
> >
> > Now try understand init process working drivers and diff with linux.
> >
> > P.S. Linux kernel is 2.6.33
> >
> > With my best regards, Dmitry.
> >
