Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45368 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaCYVW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 17:22:28 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so954059eek.10
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 14:22:26 -0700 (PDT)
Date: Tue, 25 Mar 2014 22:22:22 +0100
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 11/11] libdvbv5: fix PMT parser
Message-ID: <20140325222222.0fd23199@neutrino.exnihilo>
In-Reply-To: <87vbv2c87u.fsf@nemi.mork.no>
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
	<1395771601-3509-11-git-send-email-neolynx@gmail.com>
	<87vbv2c87u.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Mar 2014 21:51:49 +0100
Bjørn Mork <bjorn@mork.no> wrote:

> > - * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
> > - * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> > + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
> >   *
> >   * This program is free software; you can redistribute it and/or
> >   * modify it under the terms of the GNU General Public License
> 
> This copyright change looked strange to me.  Accidental deletion?

Hi Bjørn,

thanks for pointing this out.
originally I was adding mauro to my dvb files as the "owner" of dvb in
v4l. mauro then stated on some files that this was not his code and as
the PMT is originally my code, I corrected this here.

@mauro: please correct me if I'm wrong...

I'm a bit confused about the copyright year and author. Is this still
needed in the age of git ? What is the policy for them ?

regards,
 andré
