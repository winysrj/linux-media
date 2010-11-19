Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.128.24]:19301 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab0KSN21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:28:27 -0500
Date: Fri, 19 Nov 2010 15:29:28 +0200
From: David Cohen <david.cohen@nokia.com>
To: ext Lane Brooks <lane@brooks.nu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Translation faults with OMAP ISP
Message-ID: <20101119132927.GD13490@esdhcp04381.research.nokia.com>
References: <4CE16AA2.3000208@brooks.nu>
 <201011160001.10737.laurent.pinchart@ideasonboard.com>
 <4CE317D3.2020504@brooks.nu>
 <201011180009.31053.laurent.pinchart@ideasonboard.com>
 <4CE46281.2010308@brooks.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE46281.2010308@brooks.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Lane,

On Thu, Nov 18, 2010 at 12:17:21AM +0100, ext Lane Brooks wrote:
> On 11/17/2010 04:09 PM, Laurent Pinchart wrote:
> > Hi Lane,
> >
> > On Wednesday 17 November 2010 00:46:27 Lane Brooks wrote:
> >> Laurent,
> >>
> >> I am getting iommu translation errors when I try to use the CCDC output
> >> after using the Resizer output.
> >>
> >> If I use the CCDC output to stream some video, then close it down,
> >> switch to the Resizer output and open it up and try to stream, I get the
> >> following errors spewing out:
> >>
> >> omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00 translation
> >> fault
> >> omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034
> >> *pgd:00000000
> >>
> >> and the select times out.
> >>
> >>   From a fresh boot, I can stream just fine from the Resizer and then
> >> switch to the CCDC output just fine. It is only when I go from the CCDC
> >> to the Resizer that I get this problem. Furthermore, when it gets into
> >> this state, then anything dev node I try to use has the translation
> >> errors and the only way to recover is to reboot.
> >>
> >> Any ideas on the problem?
> > Ouch. First of all, could you please make sure you run the latest code ? Many
> > bugs have been fixed in the last few months
> 
> I had a pretty good idea that this would be your response, but I was 
> hoping otherwise as merging has become more and more difficult to keep 
> up with. Anyway, until I have a chance to merge in everything, I just 
> found a work around for our usage needs, and that is to always use the 
> resizer output and just change the resizer format between full 
> resolution and preview resolution. This has turned out to be much more 
> stable than switching between the CCDC and RESIZER dev nodes.

I'm not sure if it's your case, but OMAP3 ISP driver does not support
pipeline with multiples outputs yet. We have to return error from the
driver in this case. If you configured CCDC to write to memory and then
to write to preview/resizer afterwards without deactivating the link to
write to memory, you may face a similar problem you described.

Can you please try a patch I've sent to you (CC'ing linux-media) with subject:
"[omap3isp][PATCH] omap3isp: does not allow pipeline with multiple video
outputs yet"?

Regards,

David


> 
> Thanks again for your feedback.
> 
> Lane
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
