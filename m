Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35886 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbbDPA6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 20:58:36 -0400
Received: by lbbqq2 with SMTP id qq2so46904679lbb.3
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2015 17:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429142387.1899.57.camel@palomino.walls.org>
References: <20150410171750.GA5622@wotan.suse.de> <CALCETrUG=RiG8S9Gpiqm_0CxvxurxLTNKyuyPoFNX46EAauA+g@mail.gmail.com>
 <CAB=NE6XgNgu7i2OiDxFVJLWiEjbjBY17-dV7L3yi2+yzgMhEbw@mail.gmail.com>
 <1428695379.6646.69.camel@misato.fc.hp.com> <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com> <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de> <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
 <20150413174938.GE5622@wotan.suse.de> <1429137531.1899.28.camel@palomino.walls.org>
 <CALCETrUFtEMYh8i00ke0f939=17bAQxMDOBZMn_3yk3Nz1AnFA@mail.gmail.com> <1429142387.1899.57.camel@palomino.walls.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Apr 2015 17:58:14 -0700
Message-ID: <CALCETrWRjGYqcYPNizrbiVFwFHhrLf=8NTTCLVZh7Q6MgAWj=Q@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Andy Walls <awalls@md.metrocast.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Toshi Kani <toshi.kani@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2015 at 4:59 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2015-04-15 at 16:42 -0700, Andy Lutomirski wrote:
>> On Wed, Apr 15, 2015 at 3:38 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>
>> >
>>
>> IMO the right solution would be to avoid ioremapping the whole bar at
>> startup.  Instead ioremap pieces once the driver learns what they are.
>> This wouldn't have any of these problems -- you'd ioremap() register
>> regions and you'd ioremap_wc() the framebuffer once you find it.  If
>> there are regions of unknown purpose, just don't map them all.
>>
>> Would this be feasible?
>
> Feasible? Maybe.
>
> Worth the time and effort for end-of-life, convential PCI hardware so I
> can have an optimally performing X display on a Standard Def Analog TV
> screen?   Nope. I don't have that level of nostalgia.
>

The point is actually to let us unexport or delete mtrr_add.  We can
either severely regress performance on ivtv on PAT-capable hardware if
we naively switch it to arch_phys_wc_add or we can do something else.
The something else remains to be determined.

>
> We sort of know where some things are in the MMIO space due to
> experimentation and past efforts examining the firmware binary.
>
> Documentation/video4linux/cx2341x/fw-*.txt documents some things.  The
> driver code actually codifies a little bit more knowledge.
>
> The driver code for doing transfers between host and card is complex and
> fragile with some streams that use DMA, other streams that use PIO,
> digging VBI data straight out of card memory, and scatter-gather being
> broken on newer firmwares.  Playing around with ioremapping will be hard
> to get right and likely cause something in the code to break for the
> primary use case of the ivtv supported cards.

Ick.

If the only thing that really wants WC is the esoteric framebuffer
thing, could we just switch to arch_phys_wc_add and assume that no one
will care about the regression on new CPUs with ivtv cards?


--Andy
