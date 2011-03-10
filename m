Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:40960 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1CJPaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:30:52 -0500
Message-ID: <4D78EEA8.7060301@matrix-vision.de>
Date: Thu, 10 Mar 2011 16:30:48 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 4/4] omap3isp: lane shifter support
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <201103100113.25952.laurent.pinchart@ideasonboard.com> <4D78A390.8040500@matrix-vision.de> <201103101121.40846.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103101121.40846.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 03/10/2011 11:21 AM, Laurent Pinchart wrote:
> Hi Michael,
> 
[snip]
> I've had a closer look at the boards I have here, and it turns out one of them 
> connects a 10-bit sensor to DATA[11:2] :-/ data_lane_shift is thus needed for 
> it.
> 
> I'm fine with leaving data_lane_shift out of this patch, but can you submit a 
> second patch to add it back ? I'd rather avoid applying a patch that breaks 
> one of my boards and then have to fix it myself :-)

OK, but in that case I'd rather incorporate it into this last patch than
introduce a new patch for it.  I don't think it will be very complex and
they logically belong together.  I had just been hoping to avoid
implementing it altogether.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
