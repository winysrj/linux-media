Return-path: <mchehab@pedra>
Received: from sh.osrg.net ([192.16.179.4]:54657 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0HSPQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 11:16:31 -0400
Date: Fri, 20 Aug 2010 00:15:12 +0900
To: kyungmin.park@samsung.com
Cc: m.nazarewicz@samsung.com, linux-mm@kvack.org,
	fujita.tomonori@lab.ntt.co.jp, dwalker@codeaurora.org,
	linux@arm.linux.org.uk, corbet@lwn.net, p.osciak@samsung.com,
	broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
	hvaibhav@ti.com, hverkuil@xs4all.nl, kgene.kim@samsung.com,
	zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
References: <cover.1281100495.git.m.nazarewicz@samsung.com>
	<AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820001339N.fujita.tomonori@lab.ntt.co.jp>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 18 Aug 2010 12:01:35 +0900
Kyungmin Park <kyungmin.park@samsung.com> wrote:

> Are there any comments or ack?
> 
> We hope this method included at mainline kernel if possible.
> It's really needed feature for our multimedia frameworks.

You got any comments from mm people?

Virtually, this adds a new memory allocator implementation that steals
some memory from memory allocator during boot process. Its API looks
completely different from the API for memory allocator. That doesn't
sound appealing to me much. This stuff couldn't be integrated well
into memory allocator?
