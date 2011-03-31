Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51219 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab1CaQ0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 12:26:50 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
	"Ankita Garg" <ankita@in.ibm.com>,
	"Daniel Walker" <dwalker@codeaurora.org>,
	"Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
	"Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
 <1301587361.31087.1040.camel@nimitz>
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	"Dave Hansen" <dave@linux.vnet.ibm.com>
Date: Thu, 31 Mar 2011 18:26:45 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1301587361.31087.1040.camel@nimitz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
>> +       ret = 0;
>> +       while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
>> +               if (WARN_ON(++ret >= MAX_ORDER))
>> +                       return -EINVAL;

On Thu, 31 Mar 2011 18:02:41 +0200, Dave Hansen wrote:
> Holy cow, that's dense.  Is there really no more straightforward way to
> do that?

Which part exactly is dense?  What would be qualify as a more
straightforward way?

> In any case, please pull the ++ret bit out of the WARN_ON().  Some
> people like to do:
>
> #define WARN_ON(...) do{}while(0)
>
> to save space on some systems.

I don't think that's the case.  Even if WARN_ON() decides not to print
a warning, it will still return the value of the argument.  If not,
a lot of code will brake.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
