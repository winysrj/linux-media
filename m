Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:42030 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1FMS2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 14:28:01 -0400
Message-ID: <4DF656A7.5020709@free.fr>
Date: Mon, 13 Jun 2011 20:27:51 +0200
From: Robert Jarzmik <robert.jarzmik@free.fr>
Reply-To: robert.jarzmik@free.fr
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Teresa_G=E1mez?= <t.gamez@phytec.de>
Subject: Re: [PATCH 1/2] V4L: mt9m111: propagate higher level abstraction
 down in functions
References: <Pine.LNX.4.64.1106061918010.11169@axis700.grange> <4DED36A8.5000300@free.fr> <Pine.LNX.4.64.1106071159030.31635@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106071159030.31635@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/07/2011 12:02 PM, Guennadi Liakhovetski wrote:
>
> A general question to you: from your comments I haven't understood: have
> you also tested the patches or only reviewed them?

I had reviewed them so far.

Now, please have my :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

The ack includes a test done on my platform, with a suspend in the 
middle of an image capture. The system wakes up and sends back the 
captured image without a problem.
The test is for your 2 patch series : "mt9m111: propagate higher level 
abstraction down in functions" and v2 of "pxa-camera: minor updates".

Cheers.

--
Robert
