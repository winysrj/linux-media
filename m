Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48410 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0KSKdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 05:33:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <david.cohen@nokia.com>
Subject: Re: [omap3isp][PATCH v2 5/9] omap3isp: Remove unused CBUFF register access
Date: Fri, 19 Nov 2010 11:33:18 +0100
Cc: ext Sergio Aguirre <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com> <1289831401-593-6-git-send-email-saaguirre@ti.com> <20101119101944.GC13490@esdhcp04381.research.nokia.com>
In-Reply-To: <20101119101944.GC13490@esdhcp04381.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191133.19016.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi David,

On Friday 19 November 2010 11:19:44 David Cohen wrote:
> On Mon, Nov 15, 2010 at 03:29:57PM +0100, ext Sergio Aguirre wrote:

[snip]

> > @@ -244,26 +239,6 @@
> > 
> >  #define ISP_CSIB_SYSCONFIG		ISPCCP2_SYSCONFIG
> >  #define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
> > 
> > -/* ISP_CBUFF Registers */
> > -
> > -#define ISP_CBUFF_SYSCONFIG		(0x010)
> > -#define ISP_CBUFF_IRQENABLE		(0x01C)
> > -
> > -#define ISP_CBUFF0_CTRL			(0x020)
> > -#define ISP_CBUFF1_CTRL			(0x024)
> > -
> > -#define ISP_CBUFF0_START		(0x040)
> > -#define ISP_CBUFF1_START		(0x044)
> > -
> > -#define ISP_CBUFF0_END			(0x050)
> > -#define ISP_CBUFF1_END			(0x054)
> > -
> > -#define ISP_CBUFF0_WINDOWSIZE		(0x060)
> > -#define ISP_CBUFF1_WINDOWSIZE		(0x064)
> > -
> > -#define ISP_CBUFF0_THRESHOLD		(0x070)
> > -#define ISP_CBUFF1_THRESHOLD		(0x074)
> > -
> 
> No need to remove the registers from header file. We're not using them
> on current version, but it doesn't mean we won't use ever. :)

I would have made the same comment for other registers, but we're not using 
the CBUFF module at all here, with no plans to use it in the future. It might 
not be worth it keeping the register definitions. I have no strong feeling 
about it, I'm fine with both choices.

-- 
Regards,

Laurent Pinchart
