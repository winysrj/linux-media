Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab3CDTml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 14:42:41 -0500
Date: Mon, 4 Mar 2013 16:42:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti
	<alfredodelaiti@netscape.net>, linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130304164234.18df36a7@redhat.com>
In-Reply-To: <20130303134051.6dc038aa@redhat.com>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
	<20130303134051.6dc038aa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Mar 2013 13:40:51 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Sun, 03 Mar 2013 11:50:25 -0300
> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
> 
> 
> > The new data replacement in mb86a20s
> > 
> > /*
> >   * Initialization sequence: Use whatevere default values that PV SBTVD
> >   * does on its initialisation, obtained via USB snoop
> >   */
> > static struct regdata mb86a20s_init[] = {
> 
> Please test first my mb86a20s patchset. If it doesn't work, we'll need
> to dig into the differences.
> 
> The better is to group these and reorder them to look like what's there
> at the driver, and send it like a diff. That would make a way easier to
> see what's different there.
> 
> Anyway, it follows my comments about a few things that came into my eyes.
> 
> >      { 0x09, 0x3a },
> 
> No idea what's here, but it seems a worth trial to change it.

It controls inversion. I just pushed a patch that will let it handle
both normal and inverted spectrum. The DVB core will automatically
switch inversion during device tuning.

> >      { 0x28, 0x2a },
> >      { 0x29, 0x00 },
> >      { 0x2a, 0xfd },
> >      { 0x2b, 0xc8 },
> 
> Hmm... the above may explain why it is not working. This is calculated
> from the XTAL frequency, and IF (if different than 4MHz).
> 
> Just changing it could fix the issue.

I also added a patch that allows using a different XTAL frequency.

You can use the calculus there to convert from 0x00fdc8 into the XTAL
frequency, if you have the IF set by xc5000.

Regards,
Mauro
