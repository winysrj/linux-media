Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3AXUzo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 15:55:44 -0500
Date: Thu, 24 Jan 2013 18:39:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Steinar H. Gunderson" <sesse@samfundet.no>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Status of the patches under review at LMML (35 patches)
Message-ID: <20130124183957.2e81cac4@redhat.com>
In-Reply-To: <CAHFNz9JjP1ZjLM67SA-01raNKcoUjVmD8-2JfkDe=hHAB61Lig@mail.gmail.com>
References: <20130106113455.329ad868@redhat.com>
	<CAHFNz9JjP1ZjLM67SA-01raNKcoUjVmD8-2JfkDe=hHAB61Lig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steinar,

Please see the comments below.

Regards,
Mauro

Em Tue, 15 Jan 2013 16:57:26 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> > Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> Simply a cosmetic patch. Doesn't bring any advantage. Knowing what
>  MMIO address failed doesn't help at all. If you have failures, then you
> will have failures with the entire mapped addresses. So AFAICT, this
> patch doesn't bring any advantage to help in additional debugging either.
> 
> 
> > Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> 
> This is actually sleeping in interrupt context. All it does is a cosmetic
> name change and adding a mutex across the IRQ handler, which is
>  not a valid thing to do.
> 
> > Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> 
> Use of volatile .. I am not sure. It does need a lock someplace, but I am
> not sure whether this patch is doing correctly at all.

True.

Steinar, volatile generally doesn't work in kernel. You should either use
RCU, atomic_t or some locking to protect the data access instead.

> 
> 
> > Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> 
> The enumeration holds the status of the SmartBuffer, currently it is not
> being checked against. Deleting it might not be a useful thing.. ? Though
> the gpif_status in the mantis_dev structure could be removed, thus
> removing a dereference.
> 
> 
> > Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> Patch is correct, but likely needs to be regenerated, being dependant on
> another patch
> 
> 
> > Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> There is something really wrong going on. The CPU went into a loop and
> hence reads do not return. Ignoring timeouts doesn't seem the proper way
> to me.
> 
> 
> > Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> Not yet there.


-- 

Cheers,
Mauro
