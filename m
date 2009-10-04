Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:46043 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZJDKqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 06:46:15 -0400
Received: by ewy7 with SMTP id 7so2671706ewy.17
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 03:45:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091003092800.27fbafb8@tele>
References: <20090914111757.543c7e77@blackbart.localnet.prv>
	 <20090915124106.35ad1382@tele>
	 <62e5edd40910010623w58232a7cnf77a2e0c3679aab3@mail.gmail.com>
	 <20091003092800.27fbafb8@tele>
Date: Sun, 4 Oct 2009 12:45:36 +0200
Message-ID: <62e5edd40910040345w6e20f2f4q4af0ae74b5b1cb9d@mail.gmail.com>
Subject: Re: Race in gspca main or missing lock in stv06xx subdriver?
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: James Blanford <jhblanford@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/3 Jean-Francois Moine <moinejf@free.fr>:
> On Thu, 1 Oct 2009 15:23:29 +0200
> Erik Andrén <erik.andren@gmail.com> wrote:
>
>> 2009/9/15 Jean-Francois Moine <moinejf@free.fr>:
>        [snip]
>> > I think you may have found a big problem, and this one should exist
>> > in all drivers!
>> >
>> > As I understood, you say that the URB completion routine (isoc_irq)
>> > may be run many times at the same time.
>        [snip]
>> > Then, to fix this problem, I see only one solution: have a private
>> > tasklet to do the video streaming, as this is done for some bulk
>> > transfer...
>        [snip]
>> Are you currently working on anything addressing this issue or do we
>> need some further discussion?
>
> Hi Erik,
>
> No, I am not working on this problem: I cannot reproduce it (easy test:
> have a static variable which is incremented in the irq function -
> isoc_irq() in gspca.c - and warn when it is non null at entry).
>
> May you (or anyone) check it?
>
> Then, the simplest solution is not a tasklet, but to use only one URB
> (change the '#define DEF_NURBS' to 1 instead of 3 in gspca.c).
>

But this would result in reduced performance for all gspca subdrivers, no?

Best regards,
Erik


> Best regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
