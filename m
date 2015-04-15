Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34371 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbDOXws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 19:52:48 -0400
Received: by laat2 with SMTP id t2so44637358laa.1
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2015 16:52:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429138212.1899.34.camel@palomino.walls.org>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <1429138212.1899.34.camel@palomino.walls.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Apr 2015 16:52:26 -0700
Message-ID: <CALCETrU9FEoXgWxV+XXwRdKTxUxYj7CD3ropnFb4Pq1cMkucaQ@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Andy Walls <awalls@md.metrocast.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, linux-rdma@vger.kernel.org,
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

On Wed, Apr 15, 2015 at 3:50 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2015-04-15 at 13:42 -0700, Andy Lutomirski wrote:
>> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>>
>> > c) ivtv: the driver does not have the PCI space mapped out separately, and
>> > in fact it actually does not do the math for the framebuffer, instead it lets
>> > the device's own CPU do that and assume where its at, see
>> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
>> > but not a setter. Its not clear if the firmware would make a split easy.
>> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
>> >
>>
>> IMO this should be conceptually easy to split.  Once we get the
>> framebuffer address, just unmap it (or don't prematurely map it) and
>> then ioremap the thing.
>
> Not so easy.  The main ivtv driver has already set up the PCI device and
> done the mapping for the MPEG-2 decoder/video output engine.  The video
> decoder/output device nodes might already be open by user space calling
> into the main driver, before the ivtvfb module is even loaded.

Surely the MPEG-2 decoder/video engine won't overlap the framebuffer,
though.  Am I missing something?

--Andy

>
> This could be mitigated by integrating all the ivtvfb module code into
> the main ivtv module.  But even then not every PVR-350 owner wants to
> use the video output OSD as a framebuffer.  Users might just want an
> actual OSD overlaying their TV video playback.
>
> Regards,
> Andy
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
