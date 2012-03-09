Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:37154 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2CINCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 08:02:13 -0500
Message-ID: <4F59FD87.4030506@matrix-vision.de>
Date: Fri, 09 Mar 2012 13:54:31 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: jean-philippe francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: Lockup on second streamon with omap3-isp
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com> <2747531.0sXdUv33Rd@avalon> <CAGGh5h13mOVtWPLGowvtvZM1Ufx2PST3DCokJzspGFcsUo=FiA@mail.gmail.com> <2243690.V1TtfkZKP0@avalon>
In-Reply-To: <2243690.V1TtfkZKP0@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/09/2012 11:42 AM, Laurent Pinchart wrote:
> Hi Jean-Philippe,
>
[snip]
>  From my experience, the ISP doesn't handle free-running sensors very well.
> There are other things it doesn't handle well, such as sensors stopping in the
> middle of the frame. I would consider this as limitations.

Considering choking on sensors which stop in the middle of the frame- is 
this just a limitation of the driver, or is it really a limitation of 
the ISP hardware itself?  It is at least a limitation of the driver 
because we rely on the VD1 and VD0 interrupts, so we'll of course have 
problems if we never get to the last line.  But isn't it conceivable to 
use HS_VS to do our end-of-frame stuff instead of VD0?  Maybe then the 
ISP would be OK with frames that ended early, as long as they had 
reached VD1.  Then of course, you could move VD1 to an even earlier 
line, even to the first line.

Do you think that's possible?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
