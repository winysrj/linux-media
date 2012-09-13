Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57921 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2IMTga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 15:36:30 -0400
Received: by oago6 with SMTP id o6so2218847oag.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 12:36:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505225E6.7020809@netmaster.dk>
References: <5050AC4A.8070003@netmaster.dk>
	<CAGoCfizcU_oe7Go_-xH1CkWsTvdVcFgBNL8PCG8F8UnxiF4TOA@mail.gmail.com>
	<505225E6.7020809@netmaster.dk>
Date: Thu, 13 Sep 2012 15:36:29 -0400
Message-ID: <CAGoCfizVYw8SVqUADU6xCefgWVBrV0yJuqeVUzrKqfZw9ngvgA@mail.gmail.com>
Subject: Re: hdpvr and HD PVR 2 Gaming Edition from Haoppauge
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thomas Seilund <tps@netmaster.dk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2012 at 2:28 PM, Thomas Seilund <tps@netmaster.dk> wrote:
> Do you know if anybody plans to make a driver?

I have not heard of any such plans.  It's a brand new device though,
so it's possible that somebody will step up to do such (especially if
the original HD-PVR stops being sold).

> I would love to contribute but my skills are not quite there!
>
> I have looked at the code for hdpvr kernel driver and I will try to pick up
> more knowledge from the internet.
>
> Do you have any hints on where to look?

The Linuxtv.org wiki has some docs on creating Linux USB drivers
(techniques for reverse engineering Windows drivers, collecting USB
bus traces, etc).  Normally I might suggest that you try to find the
datasheets for all the chips involved, but I can tell you that you
won't find them publicly available.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
