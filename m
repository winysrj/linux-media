Return-path: <mchehab@localhost>
Received: from bear.ext.ti.com ([192.94.94.41]:33186 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1GFFk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 01:40:56 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 6 Jul 2011 11:10:37 +0530
Subject: RE: [ RFC PATCH 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73B@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <20110630135736.GK12671@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com>
 <201107041522.37437.laurent.pinchart@ideasonboard.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73A@dbde02.ent.ti.com>
 <4E11E695.9090508@iki.fi>
In-Reply-To: <4E11E695.9090508@iki.fi>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


Hi Sakari,

 On Mon, Jul 04, 2011 at 21:43:09, Sakari Ailus wrote:
> Hadli, Manjunath wrote:
> > Thank you Laurent.
> 
> Hi Manjunath,
> 
> > On Mon, Jul 04, 2011 at 18:52:37, Laurent Pinchart wrote:
> >> Hi Manjunath,
> >> 
> >> On Monday 04 July 2011 07:58:06 Hadli, Manjunath wrote:
> >>> On Thu, Jun 30, 2011 at 19:27:36, Sakari Ailus wrote:
> >> 
> >> [snip]
> >> 
> >>>> I understand that not all the blocks are there. Are there any major 
> >>>> functional differences between those in Davinci and those in OMAP 
> >>>> 3? Could the OMAP 3 ISP driver made support Davinci ISP as well?
> >>> 
> >>> Yes, there are a lot of major differences between OMAP3 and 
> >>> Dm365/Dm355, both in terms of features, there IP, and the software 
> >>> interface, including all the registers which are entirely different. 
> >>> The closest omap3 would come to is only to DM6446. I do not think 
> >>> OMAP3 driver can be made to support Dm355 and Dm365. It is good to 
> >>> keep the OMAP3 neat and clean to cater for OMAP4 and beyond, and 
> >>> keep the Davinci family separate. The names might look similar and 
> >>> hence confusing for you, but the names can as well be made the same 
> >>> as Dm365 blocks like ISIF and IPIPE and IPIPEIF which are different.
> >> 
> >> The DM6446 ISP is very similar to the OMAP3 ISP, and thus quite 
> >> different from the DM355/365 ISPs. Should the DM6446 be supported by 
> >> the OMAP3 ISP driver, and the DM355/365 by this driver ?
> > 
> > DM6446 capture IP is in some respects similar to OMAP3 for some 
> > features, but there are a large number of differences also (MMU, VRFB, 
> > a lot of display interfaces etc). Having a single driver catering to 
> > Since DM6446 and OMAP3 is going to be unwieldy. Also,
> > DM6446 belongs to the Davinci family of chips, it should be clubbed 
> > with the other Davinci SoCs as it will simplify a lot of other things 
> > including directory subdirectory/file naming, organization of 
> > machine/platform code etc among other things. Other than Video a lot 
> > of other system registers and features which are common with the rest 
> > of Davinci SoCs which if treated together is a good thing, whereas
> > OMAP3 can be modified and developed with those on the OMAP family
> > (OMAP4 for ex).
> 
> Thanks for the clarifications.
> 
> What about the DM3730? As far as I understand, the ISP on that one is supported by the OMAP 3 ISP driver. But it looks like that it's more continuation for the OMAP family of the chips than the Davinci.
Let me say that for all practical purposes, for developers, DM3730 is OMAP3. So a distinction between OMAP3 and DM3730 need not be made at all. As to why it is a Davinci device, has more to do with things outside the realm of development. So Dm3730 for us, including you and me, can be OMAP3, As the TRM says - " It is OMAP3 compatible".

> 
> I glanced at the DM6446 documentation and at the register level the interface looks somewhat different although some register names are the same. I didn't found a proper TRM which would be as detailed as the OMAP ones --- does TI have one available in public?
TRMs for Davinci devices are slightly in a different format - split into multiple documents for each peripheral and system functionalities unlike a big singe doc for OMAP.
But all the required documents are in public domain and can be found at :
http://focus.ti.com/docs/prod/folders/print/tms320dm6446.html  under the user guides category. If you are looking for some particular information, let me know and I can help you locate it.



> 
> OMAP 4 has a quite different ISS --- which the ISP is a part of, and which also is very different to the OMAP 3 one  --- so it's unlikely that the same driver would support OMAP 3 and OMAP 4 ISPs.
> 
> Kind regards,
> 
> --
> Sakari Ailus
> sakari.ailus@iki.fi
> 

Regards,
-Manjunath
