Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34363 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbbDUWIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 18:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <20150421220219.GX5622@wotan.suse.de>
References: <1428695379.6646.69.camel@misato.fc.hp.com> <20150410210538.GB5622@wotan.suse.de>
 <1428699490.21794.5.camel@misato.fc.hp.com> <CALCETrUP688aNjckygqO=AXXrNYvLQX6F0=b5fjmsCqqZU78+Q@mail.gmail.com>
 <20150411012938.GC5622@wotan.suse.de> <CALCETrXd19C6pARde3pv-4pt-i52APtw5xs20itwROPq9VmCfg@mail.gmail.com>
 <20150413174938.GE5622@wotan.suse.de> <1429137531.1899.28.camel@palomino.walls.org>
 <20150415235816.GG5622@wotan.suse.de> <1429146457.1899.99.camel@palomino.walls.org>
 <20150421220219.GX5622@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 21 Apr 2015 15:08:09 -0700
Message-ID: <CAB=NE6UFOi_CYbrgYGCfU3Uki30iGdPPL2+V5RLYww=NS7G0GA@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hyong-Youb Kim <hykim@myri.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
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
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 21, 2015 at 3:02 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> Andy, can we live without MTRR support on this driver for future kernels? This
> would only leave ipath as the only offending driver.

Sorry to be clear, can we live with removal of write-combining on this driver?

 Luis
