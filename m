Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46546 "HELO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753125AbZLMS7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 13:59:44 -0500
Received: by vws30 with SMTP id 30so443113vws.33
        for <linux-media@vger.kernel.org>; Sun, 13 Dec 2009 10:59:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260729576.2469.5.camel@hercules.rochet.org>
References: <267bb6670912120230m59eeeeffqc52cfb320ac05ec2@mail.gmail.com>
	 <200912121359.16169.liplianin@me.by>
	 <1260633864.2329.4.camel@hercules.rochet.org>
	 <a3ef07920912122043u2aaec2c6vd3d5296cdaae4c22@mail.gmail.com>
	 <1260729576.2469.5.camel@hercules.rochet.org>
Date: Sun, 13 Dec 2009 10:59:40 -0800
Message-ID: <a3ef07920912131059s79e5cefbw7b42d6b698996c5d@mail.gmail.com>
Subject: Re: [linux-dvb] Is there somobody dealing with DVB cards here ?!?
From: VDR User <user.vdr@gmail.com>
To: dvblinux <dvblinux@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 13, 2009 at 10:39 AM, dvblinux <dvblinux@free.fr> wrote:
> My question was specific:

Asking if people deal with DVB-T/DVB-S is really generic.  There's
nothing specific about it.  See below.

> Support for device ASUS (1043:48cd) lacks in current saa driver;
>
> I managed to make it work by modifying current version, since it's a
> clone of ASUS (1043:4876) device;
>
> How could I share this, if this list is the relevant audience of
> linux-dvb stuff.
>
> Perhaps this list is NOT the right place to deal with dvb driver
> development, I don't know.

You should have posted all this the first time but to answer your
questions..  Create a patch and post it with an explanation of what it
does.  Someone will likely sign-off on it as long as there's no
problems.  Yes, this is the right list for media-related things.

Regards.
