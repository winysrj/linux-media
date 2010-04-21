Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:44768 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0DULRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 07:17:49 -0400
Message-ID: <4BCEDF8A.4030706@cam.ac.uk>
Date: Wed, 21 Apr 2010 12:20:42 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: move fifo reset direct before dma start
References: <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>	<Pine.LNX.4.64.1004200905250.5292@axis700.grange>	<87ljciyqk2.fsf@free.fr> <20100421120656.0fcc2cea.ospite@studenti.unina.it>
In-Reply-To: <20100421120656.0fcc2cea.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/10 11:06, Antonio Ospite wrote:
> On Tue, 20 Apr 2010 19:36:13 +0200
> Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> 
>> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>>
>>> Robert, what do you think? Are you still working with PXA camera?
>> Hi Guennadi,
>>
>> Yes, I'm still working with pxa_camera :)
>>
>> About the patch, I have a very good feeling about it. I have not tested it, but
>> it looks good to me. I'll assume Stefan has tested it, and if you want it,
>> please take my :
>> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
>>
> 
> FWIW,
> Tested-by: Antonio Ospite <ospite@studenti.unina.it>
> 
> It works on Motorola A780: pxa_camera + mt9m111
> The first picture is now ok.
> 
> Thanks Stefan.
> 
> Ciao ciao,
>    Antonio
> 
Excellent, I'm not in a position to test right now, but glad
to see this issue cleaned up.

Jonathan
