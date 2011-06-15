Return-path: <mchehab@pedra>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33415 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1FONNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 09:13:22 -0400
Message-ID: <4DF8AFB5.10205@vmware.com>
Date: Wed, 15 Jun 2011 15:12:21 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Daniel Walker <dwalker@codeaurora.org>, linux-mm@kvack.org,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	Michal Nazarewicz <mina86@mina86.com>,
	linaro-mm-sig@lists.linaro.org,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator
 added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>	<201106141803.00876.arnd@arndb.de>	<op.vw2r3xrj3l0zgt@mnazarewicz-glaptop>	<201106142030.07549.arnd@arndb.de> <BANLkTi=XTJuF4np7+rYHzJqWK20OxMrBsw@mail.gmail.com>
In-Reply-To: <BANLkTi=XTJuF4np7+rYHzJqWK20OxMrBsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/15/2011 01:53 PM, Daniel Vetter wrote:
> On Tue, Jun 14, 2011 at 20:30, Arnd Bergmann<arnd@arndb.de>  wrote:
>    
>> On Tuesday 14 June 2011 18:58:35 Michal Nazarewicz wrote:
>>      
>>> Ah yes, I forgot that separate regions for different purposes could
>>> decrease fragmentation.
>>>        
>> That is indeed a good point, but having a good allocator algorithm
>> could also solve this. I don't know too much about these allocation
>> algorithms, but there are probably multiple working approaches to this.
>>      
> imo no allocator algorithm is gonna help if you have comparably large,
> variable-sized contiguous allocations out of a restricted address range.
> It might work well enough if there are only a few sizes and/or there's
> decent headroom. But for really generic workloads this would require
> sync objects and eviction callbacks (i.e. what Thomas Hellstrom pushed
> with ttm).
>    

Indeed, IIRC on the meeting I pointed out that there is no way to 
generically solve the fragmentation problem without movable buffers. 
(I'd do it as a simple CMA backend to TTM). This is exactly the same 
problem as trying to fit buffers in a limited VRAM area.

/Thomas


