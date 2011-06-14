Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1FNNzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 09:55:22 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	"Arnd Bergmann" <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
 <201106101821.50437.arnd@arndb.de>
 <006a01cc29a9$1394c330$3abe4990$%szyprowski@samsung.com>
 <201106141549.29315.arnd@arndb.de>
Date: Tue, 14 Jun 2011 15:55:19 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vw2jmhir3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106141549.29315.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 14 Jun 2011 15:49:29 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> Please explain the exact requirements that lead you to defining multiple
> contexts.

Some devices may have access only to some banks of memory.  Some devices
may use different banks of memory for different purposes.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
