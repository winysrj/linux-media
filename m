Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4785 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1BXL5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 06:57:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] ISP lane shifter support
Date: Thu, 24 Feb 2011 12:57:39 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <4D394675.90304@matrix-vision.de> <201102111406.05322.laurent.pinchart@ideasonboard.com> <4D63ADB8.7030304@matrix-vision.de>
In-Reply-To: <4D63ADB8.7030304@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241257.39230.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Sorry for the delay, the last 2-3 weeks were very busy.

On Tuesday, February 22, 2011 13:36:08 Michael Jones wrote:
> Hans, can you weigh in on this?  I'm waiting to submit a patch to
> implement lane shifter support until I get a consensus what the best
> approach is.  Laurent and Sakari favor having a different format on the
> sensor output than on the CCDC input to indicate a shift.
> 
> If you agree that this is a sensible approach, I will go ahead and
> submit my patch soon.

I think this is a sensible approach as well. So you can go ahead!

Regards,

	Hans

> 
> thanks,
> Michael
> 
> On 02/11/2011 02:06 PM, Laurent Pinchart wrote:
> > Hi Michael,
> > 
> > On Friday 11 February 2011 13:07:33 Michael Jones wrote:
> >> On 01/27/2011 12:46 AM, Guennadi Liakhovetski wrote:
> >>> Looking at the "Data-Lane Shifter" table (12.27 in my datasheet, in the
> >>> "Bridge-Lane Shifter" chapter), I think, the first two columns are fixed
> >>> by the board design, right? So, our freedom lies only in one line there
> >>> and is a single parameter - the shift value. The output shifter (VPIN) is
> >>> independent from this one, but not unrelated. It seems logical to me to
> >>> relate the former one to CCDC's input pad, and the latter one to CCDC's
> >>> output pad. AFAIU, Laurent, your implementation in what concerns pad
> >>> configuration is: let the user configure all interfaces independently,
> >>> and first when we have to actually activate the pipeline (start
> >>> streaming or configure video buffers) we can verify, whether all parts
> >>> fit together.
> >>
> >> I would like to add this lane shifter support.  Would you like me to
> >> implement it as Guennadi suggested- letting the user set all 3 CCDC pad
> >> formats arbitrarily and postpone the consistency checks to streamon time?
> > 
> > I've discussed this with Sakari Ailus, and we would implement it with 
> > different formats on the sensor output and the CCDC input. I'd like to get 
> > Hans Verkuil's opinion.
> > 
> 
> 
> MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
> Registergericht: Amtsgericht Stuttgart, HRB 271090
> Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
