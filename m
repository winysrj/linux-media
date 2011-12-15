Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:43488 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1LOIEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 03:04:31 -0500
Message-ID: <4EE9A8B6.4040102@matrix-vision.de>
Date: Thu, 15 Dec 2011 08:58:46 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: James <angweiyang@gmail.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
In-Reply-To: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On 12/15/2011 08:14 AM, James wrote:
> Hi all,
>
> I'm using an OMAP3530 board and a monochrome 12-bit grey sensor.
>
> Can anyone enlighten me why is the 12-bit grey formats at the CCDC
> input (Y12) is truncated to Y10 at the CCDC output?

There are 2 CCDC outputs: CCDC_PAD_SOURCE_OF and CCDC_PAD_SOURCE_VP. 
Only the VP (video port) truncates data to 10 bits, and it does that 
because the subdevs it feeds can only handle 10 bits max.

>
> I need to read the entire RAW 12-bit grey value from the CCDC to
> memory and the data does not pass through other OMAP3ISP sub-devices.
>
> I intend to use Laurent's yavta to capture the data to file to verify
> its operation for the moment.
>
> Can this 12-bit (Y12) raw capture be done?

Yes. If you are writing the 12-bit gray value directly into memory, you 
will use SOURCE_OF and can write the full 12-bits into memory.  You need 
to set up your media pipeline to do sensor->CCDC->OMAP3 ISP CCDC output.

>
> Thank you in adv.
>
> --
> Regards,
> James

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
