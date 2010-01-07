Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36833 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0AGVdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2010 16:33:55 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 7 Jan 2010 15:33:53 -0600
Subject: RE: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers
 to platform driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40162D43287@dlee06.ent.ti.com>
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
	<87k4vvkyo7.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23A3E@dlee06.ent.ti.com>
	<878wcbkx60.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com>
 <87r5q1ya2w.fsf@deeprootsystems.com>
In-Reply-To: <87r5q1ya2w.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

Can I remove it through a separate patch? This patch is already merged in Hans tree.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
>Sent: Thursday, January 07, 2010 2:44 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; hverkuil@xs4all.nl; davinci-linux-open-
>source@linux.davincidsp.com
>Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc
>drivers to platform driver
>
>"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:
>
>> Kevin,
>>
>>>
>>>OK, I'm not extremely familar with the whole video architecture here,
>>>but are all of these drivers expected to be doing clk_get() and
>>>clk_enable()?
>>>
>>
>> [MK]Many IPs on DaVinci VPFE would require vpss master clock. So
>> it is better to do the way I have done in my patch. So it is expected
>> that clk_get, clk_enable etc are called from other drivers as well.
>
>OK, then you are expecting to add clkdev nodes for the other devices
>as well.  That's ok.
>
>However, you still haven't answered my original question.  AFAICT,
>there are no users of the clkdev nodes "vpss_master" and "vpss_slave".
>Why not remove those and replace them with your new nodes instead of
>leaving them and adding new ones?
>
>Kevin
