Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:31217 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1GDQNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2011 12:13:14 -0400
Message-ID: <4E11E695.9090508@iki.fi>
Date: Mon, 04 Jul 2011 19:13:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [ RFC PATCH 0/8] RFC for Media Controller capture driver for
 DM365
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com> <20110630135736.GK12671@valkosipuli.localdomain> <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com> <201107041522.37437.laurent.pinchart@ideasonboard.com> <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73A@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73A@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hadli, Manjunath wrote:
> Thank you Laurent.

Hi Manjunath,

> On Mon, Jul 04, 2011 at 18:52:37, Laurent Pinchart wrote:
>> Hi Manjunath,
>> 
>> On Monday 04 July 2011 07:58:06 Hadli, Manjunath wrote:
>>> On Thu, Jun 30, 2011 at 19:27:36, Sakari Ailus wrote:
>> 
>> [snip]
>> 
>>>> I understand that not all the blocks are there. Are there any
>>>> major functional differences between those in Davinci and those
>>>> in OMAP 3? Could the OMAP 3 ISP driver made support Davinci ISP
>>>> as well?
>>> 
>>> Yes, there are a lot of major differences between OMAP3 and 
>>> Dm365/Dm355, both in terms of features, there IP, and the
>>> software interface, including all the registers which are
>>> entirely different. The closest omap3 would come to is only to
>>> DM6446. I do not think OMAP3 driver can be made to support Dm355
>>> and Dm365. It is good to keep the OMAP3 neat and clean to cater
>>> for OMAP4 and beyond, and keep the Davinci family separate. The
>>> names might look similar and hence confusing for you, but the
>>> names can as well be made the same as Dm365 blocks like ISIF and
>>> IPIPE and IPIPEIF which are different.
>> 
>> The DM6446 ISP is very similar to the OMAP3 ISP, and thus quite
>> different from the DM355/365 ISPs. Should the DM6446 be supported
>> by the OMAP3 ISP driver, and the DM355/365 by this driver ?
> 
> DM6446 capture IP is in some respects similar to OMAP3 for some
> features, but there are a large number of differences also (MMU,
> VRFB, a lot of display interfaces etc). Having a single driver
> catering to Since DM6446 and OMAP3 is going to be unwieldy. Also,
> DM6446 belongs to the Davinci family of chips, it should be clubbed
> with the other Davinci SoCs as it will simplify a lot of other things
> including directory subdirectory/file naming, organization of
> machine/platform code etc among other things. Other than Video a lot
> of other system registers and features which are common with the rest
> of Davinci SoCs which if treated together is a good thing, whereas
> OMAP3 can be modified and developed with those on the OMAP family
> (OMAP4 for ex).

Thanks for the clarifications.

What about the DM3730? As far as I understand, the ISP on that one is
supported by the OMAP 3 ISP driver. But it looks like that it's more
continuation for the OMAP family of the chips than the Davinci.

I glanced at the DM6446 documentation and at the register level the
interface looks somewhat different although some register names are the
same. I didn't found a proper TRM which would be as detailed as the OMAP
ones --- does TI have one available in public?

OMAP 4 has a quite different ISS --- which the ISP is a part of, and
which also is very different to the OMAP 3 one  --- so it's unlikely
that the same driver would support OMAP 3 and OMAP 4 ISPs.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
