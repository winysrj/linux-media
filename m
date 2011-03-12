Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:37128 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1CLN3L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 08:29:11 -0500
Message-ID: <4D7B7524.2050108@linuxtv.org>
Date: Sat, 12 Mar 2011 14:29:08 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A452C.7020700@linuxtv.org> <4D7A97BB.4020704@gmail.com>
In-Reply-To: <4D7A97BB.4020704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/11/2011 10:44 PM, Martin Vidovic wrote:
> Andreas Oberritter wrote:
>> It's rather unintuitive that some CAMs appear as ca0, while others as
>> cam0.
>>   
> Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
> as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
> transport stream. To me it  looks like an extension of the current API.

I see. This raises another problem. How to find out, which ca device
cam0 relates to, in case there are more ca devices than cam devices?

Regards,
Andreas
