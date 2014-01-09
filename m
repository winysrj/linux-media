Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.epfl.ch ([128.178.224.219]:39044 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaAIUyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jan 2014 15:54:36 -0500
Message-ID: <52CF0C87.4060102@epfl.ch>
Date: Thu, 09 Jan 2014 21:54:31 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Enrico <ebutera@users.berlios.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sebastian Reichel <sre@debian.org>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com> <5728278.SyrhtX3J9t@avalon> <52CF0612.2020303@epfl.ch> <4572159.CqBuj6p70x@avalon>
In-Reply-To: <4572159.CqBuj6p70x@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/09/2014 09:49 PM, Laurent Pinchart wrote:
> Hi Florian,
> 
> On Thursday 09 January 2014 21:26:58 Florian Vaussard wrote:
>> On 01/07/2014 05:59 PM, Laurent Pinchart wrote:
>>> On Friday 03 January 2014 12:30:33 Enrico wrote:
>>>> On Wed, Dec 18, 2013 at 11:09 AM, Enrico wrote:
>>>>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard wrote:
>>>>>> So I converted the iommu to DT (patches just sent),
>>>
>>> Florian, I've used your patches as a base for OMAP3 ISP DT work and they
>>> seem pretty good (although patch 1/7 will need to be reworked, but that's
>>> not a blocker). I've just had to fix a problem with the OMAP3 IOMMU,
>>> please see
>>>
>>> http://git.linuxtv.org/pinchartl/media.git/commit/d3abafde0277f168df0b2912
>>> b5d84550590d80b2
>>
>> According to the comments on the IOMMU/DT patches [1], some work is still
>> needed to merge these patches, mainly to support other IOMMUs (OMAP4,
>> OMAP5).
> 
> Sure, the code need to be reworked, but I believe it's going in the right 
> direction and shouldn't be too complex to fix.
> 
>> So the current base is probably ok. I will resume my work on this soon.
> 
> Great, thanks.
> 
>> What are your comments on patch 1?
> 
> I just agree with Suman that there can be multiple IOMMUs and that the 
> bus_set_iommu() call should thus be kept in the init function. The current 
> infrastructure allows multiple IOMMUs to coexist as long as they're of the 
> same type (I'm pretty sure we'll have to fix that at some point). I believe 
> the problem that patch 1/7 tries to fix is actually the right behaviour.
> 

Yes I agree also with Suman, even if I do not really like the current
"trick". With the move to DT, we can probably use something like
<phandle> <-> consumer relations to improve this.

>> I briefly looked at your fix, seems ok to me. I do not figure out how it
>> worked for me.
> 
> I was puzzled by that as well :-)
> 

Will dig into this next week as well.

Regards,

Florian
