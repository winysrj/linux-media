Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:46547 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DBMpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 08:45:05 -0400
Message-ID: <4F799F4F.9020606@mlbassoc.com>
Date: Mon, 02 Apr 2012 06:45:03 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: OMAP3ISP won't start
References: <4F799A99.9010209@mlbassoc.com> <CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com>
In-Reply-To: <CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-04-02 06:32, Enrico wrote:
> On Mon, Apr 2, 2012 at 2:24 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> Just to be clear - I did have to make a few patches to both the
>> TVP5150 driver and CCDC part of OMAP3ISP as some of the BT656
>> support is still not in Laurent's tree.  I'll send patches, etc,
>> once I get it working, but as mentioned above, at least at the
>> register level, these are set up the same as in my working tree.
>
> What patches did you add on top of Laurent tree?
>
> I had a look some days ago and for example it's missing the right
> setup for VD0/VD1 (no VD1 and VD0 set to half height), this could be
> the cause of a not working isp. You can check if you get interrupts
> from the isp (/proc/interrupts).

Getting lots of interrupts:
  24:       3376      INTC  omap-iommu.0, OMAP3 ISP

>
> Another thing that is missing is the logic in the irq handler that
> wait for a complete frame before calling next video buffer (or
> something like that).

The items you mention are just what I merged from my previous kernel.
My changes are still pretty rough but I can send them to you if you'd
like.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
