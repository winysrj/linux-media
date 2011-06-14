Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63241 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1FNSku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 14:40:50 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	"'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
	"'Ankita Garg'" <ankita@in.ibm.com>,
	"'Daniel Walker'" <dwalker@codeaurora.org>,
	"'Mel Gorman'" <mel@csn.ul.ie>,
	"'Jesse Barker'" <jesse.barker@linaro.org>
Subject: Re: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106141803.00876.arnd@arndb.de> <op.vw2r3xrj3l0zgt@mnazarewicz-glaptop>
 <201106142030.07549.arnd@arndb.de>
Date: Tue, 14 Jun 2011 20:40:46 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vw2wt8cs3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106142030.07549.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Tuesday 14 June 2011 18:58:35 Michal Nazarewicz wrote:
>> Is having support for multiple regions a bad thing?  Frankly,
>> removing this support will change code from reading context passed
>> as argument to code reading context from global variable.  Nothing
>> is gained; functionality is lost.

On Tue, 14 Jun 2011 20:30:07 +0200, Arnd Bergmann wrote:
> What is bad IMHO is making them the default, which forces the board
> code to care about memory management details. I would much prefer
> to have contiguous allocation parameters tuned automatically to just
> work on most boards before we add ways to do board-specific hacks.

I see those as orthogonal problems.  The code can have support for
multiple contexts but by default use a single global context exported
as cma_global variable (or some such).

And I'm not arguing against having “contiguous allocation parameters
tuned automatically to just work on most boards”.  I just don't see
the reason to delete functionality that is already there, does not
add much code and can be useful.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
