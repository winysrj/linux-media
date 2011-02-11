Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:42891 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1BKMHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 07:07:35 -0500
Message-ID: <4D552685.4040406@matrix-vision.de>
Date: Fri, 11 Feb 2011 13:07:33 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] ISP lane shifter support
References: <4D394675.90304@matrix-vision.de> <201101242045.24561.laurent.pinchart@ideasonboard.com> <4D3E939A.5020100@matrix-vision.de> <201101251020.22804.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1101262218090.6179@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101262218090.6179@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 01/27/2011 12:46 AM, Guennadi Liakhovetski wrote:

> Looking at the "Data-Lane Shifter" table (12.27 in my datasheet, in the 
> "Bridge-Lane Shifter" chapter), I think, the first two columns are fixed 
> by the board design, right? So, our freedom lies only in one line there 
> and is a single parameter - the shift value. The output shifter (VPIN) is 
> independent from this one, but not unrelated. It seems logical to me to 
> relate the former one to CCDC's input pad, and the latter one to CCDC's 
> output pad. AFAIU, Laurent, your implementation in what concerns pad 
> configuration is: let the user configure all interfaces independently, and 
> first when we have to actually activate the pipeline (start streaming or 
> configure video buffers) we can verify, whether all parts fit together. 

I would like to add this lane shifter support.  Would you like me to
implement it as Guennadi suggested- letting the user set all 3 CCDC pad
formats arbitrarily and postpone the consistency checks to streamon time?

> So, why don't we stay consistent and do the same here? Give the user both 
> parameters and see how clever they were in the end;) I also think, if we 
> later decide to add some consistency checks, we can always do it.
> 
> Thanks
> Guennadi

Thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
