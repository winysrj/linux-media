Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45524 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1FOLaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 07:30:52 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Zach Pfeffer" <zach.pfeffer@linaro.org>,
	"Daniel Stone" <daniels@collabora.com>,
	"Ankita Garg" <ankita@in.ibm.com>,
	"Daniel Walker" <dwalker@codeaurora.org>,
	"Jesse Barker" <jesse.barker@linaro.org>,
	"Mel Gorman" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	"Kyungmin Park" <kyungmin.park@samsung.com>,
	"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106142242.25157.arnd@arndb.de> <op.vw31uxxl3l0zgt@mnazarewicz-glaptop>
 <201106151320.42182.arnd@arndb.de>
Date: Wed, 15 Jun 2011 13:30:48 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vw37lm1a3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106151320.42182.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 15 Jun 2011 13:20:42 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> The point is that on the higher level device drivers, we want to
> hide the presence of CMA and/or IOMMU behind the dma mapping API,
> but the device drivers do need to know about the bank properties.

Gotcha, thanks.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
