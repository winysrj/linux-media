Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45285 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1ADQ7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 11:59:03 -0500
MIME-Version: 1.0
In-Reply-To: <C832F8F5D375BD43BFA11E82E0FE9FE00829C13EB2@EXDCVYMBSTM005.EQ1STM.local>
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
	<AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
	<20101223100642.GD3636@n2100.arm.linux.org.uk>
	<C832F8F5D375BD43BFA11E82E0FE9FE00829C13EB2@EXDCVYMBSTM005.EQ1STM.local>
Date: Tue, 4 Jan 2011 17:59:01 +0100
Message-ID: <AANLkTim38-vyKzKg8UDzffX2jWAJrgQNJZd=rd7gbpCc@mail.gmail.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
From: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <mina86@mina86.com>
To: Johan MOSSBERG <johan.xx.mossberg@stericsson.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Kyungmin Park <kmpark@infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Ankita Garg <ankita@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> Russell King wrote:
>> Has anyone addressed my issue with it that this is wide-open for
>> abuse by allocating large chunks of memory, and then remapping
>> them in some way with different attributes, thereby violating the
>> ARM architecture specification?

2011/1/4 Johan MOSSBERG <johan.xx.mossberg@stericsson.com>:
> Where in the specification (preferably ARMv7) can I find
> information about this? Is the problem that it is simply
> forbidden to map an address multiple times with different cache
> setting and if this is done the hardware might start failing? Or
> is the problem that having an address mapped cached means that
> speculative pre-fetch can read it into the cache at any time,
> possibly causing problems if an un-cached mapping exists?

IIRC both apply.
