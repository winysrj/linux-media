Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbZGFQa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 12:30:57 -0400
Date: Mon, 6 Jul 2009 09:29:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
cc: wuzhangjin@gmail.com, Paul Mundt <lethal@linux-sh.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@linux-mips.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
In-Reply-To: <20090706165036.d21bfaaa.krzysztof.h1@poczta.fm>
Message-ID: <alpine.LFD.2.01.0907060927561.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org> <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain> <20090705150134.GB8326@linux-sh.org>
 <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain> <20090705152557.GA10588@linux-sh.org> <20090705181808.93be24a9.krzysztof.h1@poczta.fm> <1246842791.29532.2.camel@falcon> <20090706165036.d21bfaaa.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 6 Jul 2009, Krzysztof Helt wrote:
> 
> Who should I send this patch to be included as a 2.6.31 regression fix?

Just send the patches to me. I've got the patch, but no changelog, and so 
I'd like to see them again, with changelogs and the proper "Acked-by:" or 
"Tested-by" lines etc.

		Linus
