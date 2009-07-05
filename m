Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZGEPdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2009 11:33:18 -0400
Date: Sun, 5 Jul 2009 08:32:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
In-Reply-To: <20090705152557.GA10588@linux-sh.org>
Message-ID: <alpine.LFD.2.01.0907050831260.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org> <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain> <20090705150134.GB8326@linux-sh.org>
 <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain> <20090705152557.GA10588@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 6 Jul 2009, Paul Mundt wrote:
>
> Ok, here is an updated version with an updated matroxfb and the sm501fb
> change reverted.

Wu Zhangjin, can you also confirm that this works for you (without your 
patch)?

		Linus
