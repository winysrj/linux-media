Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35147 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbDOUnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 16:43:09 -0400
Received: by lbbuc2 with SMTP id uc2so43461222lbb.2
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2015 13:43:08 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Apr 2015 13:42:47 -0700
Message-ID: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: "Luis R. Rodriguez" <mcgrof@suse.com>, linux-rdma@vger.kernel.org
Cc: Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
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

On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:

> c) ivtv: the driver does not have the PCI space mapped out separately, and
> in fact it actually does not do the math for the framebuffer, instead it lets
> the device's own CPU do that and assume where its at, see
> ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> but not a setter. Its not clear if the firmware would make a split easy.
> We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
>

IMO this should be conceptually easy to split.  Once we get the
framebuffer address, just unmap it (or don't prematurely map it) and
then ioremap the thing.

> From the beginning it seems only framebuffer devices used MTRR/WC, lately it
> seems infiniband drivers also find good use for for it for PIO TX buffers to
> blast some sort of data, in the future I would not be surprised if other
> devices found use for it.

IMO the Infiniband maintainers should fix their code.  Especially in
the server space, there aren't that many MTRRs to go around.  I wrote
arch_phys_wc_add in the first place because my server *ran out of
MTRRs*.

Hey, IB people: can you fix your drivers to use arch_phys_wc_add
(which is permitted to be a no-op) along with ioremap_wc?  Your users
will thank you.

> It may be true that the existing drivers that
> requires the above type of work are corner cases -- but I wouldn't hold my
> breath for that. The ivtv device is a good example of the worst type of
> situations and these days. So perhap __arch_phys_wc_add() and a
> ioremap_ucminus() might be something more than transient unless hardware folks
> get a good memo or already know how to just Do The Right Thing (TM).

I disagree.  We should try to NACK any new code that can't function
without MTRRs.

(Plus, ARM is growing in popularity in the server space, and ARM quite
sensibly doesn't have MTRRs.)

--Andy
