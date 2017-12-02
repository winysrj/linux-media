Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:63575 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752134AbdLBX7i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Dec 2017 18:59:38 -0500
Subject: Re: [GIT PULL] SAA716x DVB driver
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
 <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan>
 <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan>
 <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan>
 <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <20171128163554.449dcb72@vento.lan>
From: Soeren Moch <smoch@web.de>
Message-ID: <e6eda73b-50d0-adc9-98a9-dadbf8d6be7e@web.de>
Date: Sun, 3 Dec 2017 00:58:04 +0100
MIME-Version: 1.0
In-Reply-To: <20171128163554.449dcb72@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On 28.11.2017 19:35, Mauro Carvalho Chehab wrote:
> Em Mon, 25 Sep 2017 00:17:00 +0200
> Soeren Moch <smoch@web.de> escreveu:
>
>>>  What I'm saying is that,
>>> if we're adding it on staging, we need to have a plan to reimplement
>>> it to whatever API replaces the DVB video API, as this API likely
>>> won't stay upstream much longer.  
>> AFAIK it is not usual linux policy to remove existing drivers
>> with happy users and even someone who volunteered to
>> maintain this.
> The usual Linux policy doesn't apply to staging. The goal of staging is
> to add drivers that have problems, but are fixable, and whose someone
> is working to solve those issues. 
It is totally clear to me what staging is for. Therefore I submitted
this driver for staging.

I was talking about the ttpci driver. This drivers lives in
drivers/media/pci/ttpci, not in staging, it implements the DVB
audio/video/osd API, works great and has happy users. So the DVB video
API _is already_ part of the linux userspace API. This pull request does
not add anything to the already available in-kernel video API.
> The staging policies include adding a TODO file describing the problems
> that should be solved for the driver to be promoted. If such problems
> aren't solved, the driver can be removed.
Yes, of course. Therefore I added such TODO file and promised to solve
these issues.
>
> For example, this year, we removed some lirc staging drivers because
> no developers were interested (and/or had the hardware) to convert
> them to use the RC core (with is a Kernel's internal API).
>
> In the case of saa716x, the issue is that it uses a deprecated
> and undocumented userspace API, with is a way more serious issue.
Unfortunately there is no other API available which provides _all_ the
functionality of DVB audio/video/osd. And the TT S2-6400 hardware is
developed in a way, so that it is as similar as possible to ttpci cards.
In order that the vdr application can easily make use of it. So it is
not surprising, that the saa716x_ff driver needs to implement the same
APIs as the ttpci driver.
> I'm ok to add this driver to staging if we can agree on what
> should be fixed, and if someone commits to try fixing it, knowing,
> in advance, that, if it doesn't get fixed on a reasonable time, it
> can be removed on later Kernel versions.
I already agreed on all these points. I already promised to fix whatever
is necessary to get this driver out of staging, as long as the userspace
API remains the same so that vdr continues to work with these cards. And
once again, this API already is part of the kernel and not specific for
this driver.


The driver version in this pull request does not build anymore with
linux-4.15-rc1. Shall I provide a new pull request with this fixed?

Thanks,
Soeren
