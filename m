Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbZCGAAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 19:00:54 -0500
Date: Fri, 6 Mar 2009 15:59:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@infradead.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next] dvb/frontends: fix duplicate 'debug' symbol
Message-Id: <20090306155958.11b4a186.akpm@linux-foundation.org>
In-Reply-To: <49B1949E.2000300@oracle.com>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
	<49B1949E.2000300@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 06 Mar 2009 13:24:46 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> It would also be Good if arch/x86/kernel/entry_32.S didn't have a
> non-static 'debug' symbol.  OTOH, it helps catch things like this one.

heh, yes, it's a feature.  We should put it in init/main.c, along with
100-odd other dont-do-that-dopey symbols.



