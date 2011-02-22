Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:37416 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1BVMgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 07:36:10 -0500
Message-ID: <4D63ADB8.7030304@matrix-vision.de>
Date: Tue, 22 Feb 2011 13:36:08 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] ISP lane shifter support
References: <4D394675.90304@matrix-vision.de> <Pine.LNX.4.64.1101262218090.6179@axis700.grange> <4D552685.4040406@matrix-vision.de> <201102111406.05322.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102111406.05322.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans, can you weigh in on this?  I'm waiting to submit a patch to
implement lane shifter support until I get a consensus what the best
approach is.  Laurent and Sakari favor having a different format on the
sensor output than on the CCDC input to indicate a shift.

If you agree that this is a sensible approach, I will go ahead and
submit my patch soon.

thanks,
Michael

On 02/11/2011 02:06 PM, Laurent Pinchart wrote:
> Hi Michael,
> 
> On Friday 11 February 2011 13:07:33 Michael Jones wrote:
>> On 01/27/2011 12:46 AM, Guennadi Liakhovetski wrote:
>>> Looking at the "Data-Lane Shifter" table (12.27 in my datasheet, in the
>>> "Bridge-Lane Shifter" chapter), I think, the first two columns are fixed
>>> by the board design, right? So, our freedom lies only in one line there
>>> and is a single parameter - the shift value. The output shifter (VPIN) is
>>> independent from this one, but not unrelated. It seems logical to me to
>>> relate the former one to CCDC's input pad, and the latter one to CCDC's
>>> output pad. AFAIU, Laurent, your implementation in what concerns pad
>>> configuration is: let the user configure all interfaces independently,
>>> and first when we have to actually activate the pipeline (start
>>> streaming or configure video buffers) we can verify, whether all parts
>>> fit together.
>>
>> I would like to add this lane shifter support.  Would you like me to
>> implement it as Guennadi suggested- letting the user set all 3 CCDC pad
>> formats arbitrarily and postpone the consistency checks to streamon time?
> 
> I've discussed this with Sakari Ailus, and we would implement it with 
> different formats on the sensor output and the CCDC input. I'd like to get 
> Hans Verkuil's opinion.
> 


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
