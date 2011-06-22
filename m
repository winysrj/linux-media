Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1FVHcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 03:32:20 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linaro-mm-sig@lists.linaro.org, "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Arnd Bergmann" <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	"'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
	"'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	"'Jesse Barker'" <jesse.barker@linaro.org>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Ankita Garg'" <ankita@in.ibm.com>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org,
	"'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com>
 <201106150937.18524.arnd@arndb.de> <201106220903.31065.hverkuil@xs4all.nl>
Date: Wed, 22 Jun 2011 09:32:13 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vxgu7zgo3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106220903.31065.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Jun 2011 09:03:30 +0200, Hans Verkuil <hverkuil@xs4all.nl>  
wrote:
> What I was wondering about is how this patch series changes the  
> allocation in case it can't allocate from the CMA pool. Will it
> attempt to fall back to a 'normal' allocation?

Unless Marek changed something since I wrote the code, which I doubt,
if CMA cannot obtain memory from CMA region, it will fail.

Part of the reason is that CMA lacks the knowledge where to allocate
memory from.  For instance, with the case of several memory banks,
it does not know which memory bank to allocate from.

It is, in my opinion, a task for a higher level functions (read:
DMA layer) to try another mechanism if CMA fails.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
