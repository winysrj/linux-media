Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36938 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0KPXqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 18:46:31 -0500
Received: by vws13 with SMTP id 13so764342vws.19
        for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 15:46:30 -0800 (PST)
Message-ID: <4CE317D3.2020504@brooks.nu>
Date: Tue, 16 Nov 2010 16:46:27 -0700
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Translation faults with OMAP ISP
References: <4CE16AA2.3000208@brooks.nu> <4CE18EE4.7080203@brooks.nu> <201011160001.10737.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011160001.10737.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent,

I am getting iommu translation errors when I try to use the CCDC output 
after using the Resizer output.

If I use the CCDC output to stream some video, then close it down, 
switch to the Resizer output and open it up and try to stream, I get the 
following errors spewing out:

omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00 translation 
fault
omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034 
*pgd:00000000

and the select times out.

 From a fresh boot, I can stream just fine from the Resizer and then 
switch to the CCDC output just fine. It is only when I go from the CCDC 
to the Resizer that I get this problem. Furthermore, when it gets into 
this state, then anything dev node I try to use has the translation 
errors and the only way to recover is to reboot.

Any ideas on the problem?

Thanks,
Lane
