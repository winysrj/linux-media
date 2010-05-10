Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab0EJUCi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 16:02:38 -0400
Message-ID: <4BE86655.6070202@redhat.com>
Date: Mon, 10 May 2010 17:02:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] Add FE_CAN_PSK_8 to allow apps to identify PSK_8
 capable DVB devices
References: <E1OBKmg-0006RZ-4R@www.linuxtv.org> <4BE84649.3010507@tvdr.de>
In-Reply-To: <4BE84649.3010507@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Klaus Schmidinger wrote:
> On 10.05.2010 06:40, Patch from Klaus Schmidinger wrote:
>> The patch number 14692 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
>> to http://linuxtv.org/hg/v4l-dvb master development tree.
>>
>> Kernel patches in this development tree may be modified to be backward
>> compatible with older kernels. Compatibility modifications will be
>> removed before inclusion into the mainstream Kernel
>>
>> If anyone has any objections, please let us know by sending a message to:
>> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> This patch should not have been applied, as was decided in
> the original thread.

Douglas is synchronizing with git. As the revert patch is a separate patch,
he'll probably apply it later, after finishing sync with -git.

> I'm still waiting for any response to my new patch, posted in
> 
>   "[PATCH] Add FE_CAN_TURBO_FEC (was: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices)"
> 
> which replaces my original suggestion.

Your new patch is already queued at Patchwork. In order to avoid the risk 
of applying it earlier, I'm waiting for some more acks/comments before 
applying it. If nothing happens, I'll queue it for 2.6.35, since, for me
your new patch is ok.

Cheers,
Mauro
