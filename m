Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3HASsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 14:48:33 -0400
Date: Thu, 1 Aug 2013 15:48:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130801154824.77461147@infradead.org>
In-Reply-To: <51FAA45F.5070100@netscape.net>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
	<20130303134051.6dc038aa@redhat.com>
	<20130304164234.18df36a7@redhat.com>
	<51353591.4040709@netscape.net>
	<20130304233028.7bc3c86c@redhat.com>
	<513A6968.4070803@netscape.net>
	<515A0D03.7040802@netscape.net>
	<51E44DCA.8060702@netscape.net>
	<20130716053030.3fda034e.mchehab@infradead.org>
	<51E6A20B.8020507@netscape.net>
	<20130718042314.2773b7c0.mchehab@infradead.org>
	<51F40976.8090106@netscape.net>
	<20130801090436.6dfa0f68@infradead.org>
	<51FA97F0.9010206@netscape.net>
	<20130801143742.27fdc712@infradead.org>
	<51FAA45F.5070100@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 01 Aug 2013 15:09:35 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi
> 
> El 01/08/13 14:37, Mauro Carvalho Chehab escribió:
> > Em Thu, 01 Aug 2013 14:16:32 -0300
> > Alfredo Jesús Delaiti  <alfredodelaiti@netscape.net> escreveu:
> >
> >> Hi
> >>
> >> El 01/08/13 09:04, Mauro Carvalho Chehab escribió:
> >>>> I found the patch that affects the X8507 board is: commit
> >>>> a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb
> >>>>
> >>>> --------
> >>>> alfredo@linux-puon:/usr/src/git/linux> git stash
> >>>> Saved working directory and index state WIP on (no branch): c6f56e7
> >>>> [media] dvb: don't use DVBv3 bandwidth macros
> >>>> HEAD is now at c6f56e7 [media] dvb: don't use DVBv3 bandwidth macros
> >>>> alfredo@linux-puon:/usr/src/git/linux> git bisect good
> >>>> a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb is the first bad commit
> >>>> commit a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb
> >>>> Author: Mauro Carvalho Chehab <mchehab  redhat.com>
> >>>> Date:   Mon Dec 26 20:48:54 2011 -0300
> >>>>
> >>>>        [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
> >>>>
> >>>>        The cx23885-dvb driver has a dirty hack:
> >>>>            1) it hooks the DVBv3 legacy call to FE_SET_FRONTEND;
> >>>>            2) it uses internally the DVBv3 struct to decide some
> >>>>               configs.
> >>>>
> >>>>        Replace it by a change during the gate control. This will
> >>>>        likely work, but requires testing. Anyway, the current way
> >>>>        will break, as soon as we stop copying data for DVBv3 for
> >>>>        pure DVBv5 calls.
> >>>>
> >>>>        Compile-tested only.
> >>>>
> >>>>        Cc: Michael Krufky <mkrufky  linuxtv.org>
> >>>>        Signed-off-by: Mauro Carvalho Chehab <mchehab  redhat.com>
> >>>>
> >>>> :040000 040000 6d0695eb9e59b837425ed64d4e2be6625864b609
> >>>> 89700b867069ec0ad2713367e607763e91798e98 M      drivers
> >>>> --------
> >>>>
> >>>>
> >>>> I manually removed the patch, then the TV card works.
> >>>>
> >>>>
> >>>> Unfortunately my lack of knowledge prevents me fix it.
> >>>>
> >>>> I test new code with pleasure :) !
> >>> Hi Alfredo,
> >>>
> >>>
> >>> Please send me the patches you've made to make isdb-t work on
> >>> it, and I'll try to address this issue.
> >>>
> >>> Regards,
> >>> Mauro
> >>>
> >>>
> >> Mauro thank you very much for your interest.
> >>
> >> I send the patch. 3.2 is on a kernel.
> >>
> >> -----------------------------------------------------------------------
> >>
> >>    .../{ => }/media/dvb/frontends/mb86a20s.c          |  332
> >> ++++++--------------
> > Hmm... unfortunately, your emailer broke the patch. It made a total mess
> > with whitespaces. Could you please resend it in a way that whitespaces
> > won't be damaged? Otherwise, patch tool won't apply it.
> >
> > Cheers,
> > Mauro
> 
> GRRRRRRRRR
> 
> I send attached, I hope it will not break this time.

This time it arrived fine, thanks!

Btw, those changes at mb86a20s are required for it to work, or just alters
somewhat the tuning?

Regards,
Mauro
