Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43844 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964AbbICWez (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 18:34:55 -0400
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
To: Tony Lindgren <tony@atomide.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20150716125800.GN17550@atomide.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Suman Anna <s-anna@ti.com>
Message-ID: <55E8CAE7.3010301@ti.com>
Date: Thu, 3 Sep 2015 17:34:15 -0500
MIME-Version: 1.0
In-Reply-To: <20150716125800.GN17550@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/16/2015 07:58 AM, Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [150716 05:57]:
>> The OMAP3 ISP is now fully supported in DT, remove its instantiation
>> from C code.
> 
> Please feel to queue this along with the second patch in this series,
> this should not cause any merge conflicts:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Just wondering if you have already queued this, I see the v4l changes in
linux-next, but not this patch. Also, can you confirm if this series is
making it into 4.3?

regards
Suman

