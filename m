Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47485 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935680Ab0KQXJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 18:09:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: Translation faults with OMAP ISP
Date: Thu, 18 Nov 2010 00:09:30 +0100
Cc: linux-media@vger.kernel.org
References: <4CE16AA2.3000208@brooks.nu> <201011160001.10737.laurent.pinchart@ideasonboard.com> <4CE317D3.2020504@brooks.nu>
In-Reply-To: <4CE317D3.2020504@brooks.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011180009.31053.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Lane,

On Wednesday 17 November 2010 00:46:27 Lane Brooks wrote:
> Laurent,
> 
> I am getting iommu translation errors when I try to use the CCDC output
> after using the Resizer output.
> 
> If I use the CCDC output to stream some video, then close it down,
> switch to the Resizer output and open it up and try to stream, I get the
> following errors spewing out:
> 
> omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00 translation
> fault
> omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034
> *pgd:00000000
> 
> and the select times out.
> 
>  From a fresh boot, I can stream just fine from the Resizer and then
> switch to the CCDC output just fine. It is only when I go from the CCDC
> to the Resizer that I get this problem. Furthermore, when it gets into
> this state, then anything dev node I try to use has the translation
> errors and the only way to recover is to reboot.
> 
> Any ideas on the problem?

Ouch. First of all, could you please make sure you run the latest code ? Many 
bugs have been fixed in the last few months.

-- 
Regards,

Laurent Pinchart
