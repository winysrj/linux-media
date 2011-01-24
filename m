Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:35523 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1AXOQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 09:16:30 -0500
Message-ID: <4D3D89BC.8070305@matrix-vision.de>
Date: Mon, 24 Jan 2011 15:16:28 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] ISP lane shifter support
References: <4D394675.90304@matrix-vision.de> <201101240110.52703.laurent.pinchart@ideasonboard.com> <4D3D82D8.2010203@matrix-vision.de> <201101241457.44866.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101241457.44866.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 01/24/2011 02:57 PM, Laurent Pinchart wrote:
<snip>
>>>
>>> As the lane shifter is located at the CCDC input, it might be easier to
>>> implement support for this using the CCDC input format. ispvideo.c would
>>> need to validate the pipeline when the output of the entity connected to
>>> the CCDC input (parallel sensor, CCP2 or CSI2) is configured with a
>>> format that can be shifted to the format at the CCDC input.
>>
>> This crossed my mind, but it seems illogical to have a link with a
>> different format at each of its ends.
> 
> I agree in theory, but it might be problematic for the CCDC. Right now the 
> CCDC can write to memory or send the data to the preview engine, but not both 
> at the same time. That's something that I'd like to change in the future. What 
> happens if the user then sets different widths on the output pads ?
> 

Shouldn't we prohibit the user from doing this in ccdc_[try/set]_format
in the first place? By "prohibit", I mean shouldn't we be sure that the
pixel format on pad 1 is always the same as on pad 2?  Downside: this
suggests that set_fmt on pad 2 could change the fmt on pad 1, which may
be unexpected. But that does at least reflect the reality of the
hardware, right?

<snip>

Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
