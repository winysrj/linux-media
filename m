Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.218]:53914 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaAIU1D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jan 2014 15:27:03 -0500
Message-ID: <52CF0612.2020303@epfl.ch>
Date: Thu, 09 Jan 2014 21:26:58 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sebastian Reichel <sre@debian.org>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com> <CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com> <CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com> <5728278.SyrhtX3J9t@avalon>
In-Reply-To: <5728278.SyrhtX3J9t@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurant,

On 01/07/2014 05:59 PM, Laurent Pinchart wrote:
> Hi Enrico,
> 
> On Friday 03 January 2014 12:30:33 Enrico wrote:
>> On Wed, Dec 18, 2013 at 11:09 AM, Enrico wrote:
>>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard wrote:
>>>> So I converted the iommu to DT (patches just sent),
> 
> Florian, I've used your patches as a base for OMAP3 ISP DT work and they seem 
> pretty good (although patch 1/7 will need to be reworked, but that's not a 
> blocker). I've just had to fix a problem with the OMAP3 IOMMU, please see
> 
> http://git.linuxtv.org/pinchartl/media.git/commit/d3abafde0277f168df0b2912b5d84550590d80b2
> 

According to the comments on the IOMMU/DT patches [1], some work is
still needed to merge these patches, mainly to support other IOMMUs
(OMAP4, OMAP5). So the current base is probably ok. I will resume my
work on this soon. What are your comments on patch 1?

I briefly looked at your fix, seems ok to me. I do not figure out how it
worked for me. I will look at it closer next week.

> I'd appreciate your comments on that. I can post the patch already if you 
> think that would be helpful.
> 

It is probably better to wait for the v2 of the iommu series. I can
include your patch in it.

> You can find my work-in-progress branch at
> 
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp/dt
> 
> (the last three patches are definitely not complete yet).
> 

Great news! A while ago, Sebastian Reichel (in CC) posted an RFC for the
binding [2]. Are you working with him on this?

Regards,

Florian

[1] https://lkml.org/lkml/2013/12/17/197
[2] http://thread.gmane.org/gmane.linux.drivers.devicetree/50580
