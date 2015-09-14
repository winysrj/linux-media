Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44625 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbbINQab (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 12:30:31 -0400
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
To: Tony Lindgren <tony@atomide.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20150716125800.GN17550@atomide.com> <55E8CAE7.3010301@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Suman Anna <s-anna@ti.com>
Message-ID: <55F6F5FF.2060801@ti.com>
Date: Mon, 14 Sep 2015 11:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <55E8CAE7.3010301@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On 09/03/2015 05:34 PM, Suman Anna wrote:
> Hi Sakari,
> 
> On 07/16/2015 07:58 AM, Tony Lindgren wrote:
>> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [150716 05:57]:
>>> The OMAP3 ISP is now fully supported in DT, remove its instantiation
>>> from C code.
>>
>> Please feel to queue this along with the second patch in this series,
>> this should not cause any merge conflicts:
>>
>> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Just wondering if you have already queued this, I see the v4l changes in
> linux-next, but not this patch. Also, can you confirm if this series is
> making it into 4.3?
> 

This patch is not in 4.3-rc1, can you pick this up for the next merge
window? I am gonna send out some additional cleanup patches (removing
legacy mailbox and iommu pieces) on top on this patch. The second patch
in this series did make it.

regards
Suman

