Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41775 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0F1QeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 12:34:13 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 28 Jun 2010 11:34:04 -0500
Subject: RE: [omap3camera] Kernel broken when building rx51 with camera
Message-ID: <A24693684029E5489D1D202277BE894456225801@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Aguirre, Sergio
> Sent: Friday, June 25, 2010 9:03 PM
> To: Laurent Pinchart; Sakari Ailus
> Cc: linux-media@vger.kernel.org
> Subject: [omap3camera] Kernel broken when building rx51 with camera
> 
> Hi Laurent/Sakari,
> 
> Not sure what is exactly happening, but I can't get the kernel
> to build with latest omap3camera gitorious devel branch.
> 

Ahh, I just noticed a patch already for it on latest linux-omap tree.

Its an IOMMU bug when building as built-in. Here's the patch:

http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commit;h=7d9609c6f0feaf045d5b45fd3e1669837700c152

commit 7d9609c6f0feaf045d5b45fd3e1669837700c152
Author: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date:   Wed Jun 16 19:05:52 2010 +0300

    omap iommu: fix: Make omap-iommu.o built-in
    
    This also fixes the wrong overwritten for "obj-y" in the previous
    commit.
    
    Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

Sorry for the noise.

Regards,
Sergio

<snip>
