Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40884 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab0CXRdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 13:33:19 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 24 Mar 2010 12:33:13 -0500
Subject: RE: [Resubmit: PATCH-V2] Introducing ti-media directory
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A7864A6@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE4016A785F05@dlee06.ent.ti.com>
 <201003241005.51075.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201003241005.51075.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

>
>Using a dedicated directory in drivers/media/video for TI-specific cores is
>definitely a good idea (assuming the same IP cores won't be used by other
>vendors in the future).

If another vendor uses it in another SOC (assuming for discussion), then
the driver should be re-used. So there shouldn't be another version of the
driver right? So why is this an issue?

>
>My concern is that, if we move the ISP driver in drivers/media/video/ti-
>media,
>the directory will soon get quite crowded. If a new TI processor comes up
>with
>a totally incompatible ISP, we will get a name conflict in
>drivers/media/video/ti-media. I was thinking about either replacing the
>"isp"
>prefix with "omap3isp" (or similar), or moving the driver to
>drivers/media/video/ti-media/omap3isp, but that will impede code sharing
>code
>between the Davinci and OMAP processor families. That's where my
>uncertainty
>comes from.

I think vpfe is used for DM devices which is equivalent to ISP in OMAP.
omap3 CCDC/Previewer/Resizer/H3A is re-used from DM6446 CCDC or vice-versa. 
The ccdc is also re-used in AM35xxx OMAP device (excuse me if I wrote the name incorrectly) that Vaibhav is working on. So we might want to name it as just ccdc.c/resizer.c/previewer.c. Currently we have dm644x_ccdc.c under davinci for DM644x and dm355_ccdc.c for DM355. We need to sort out the differences in the driver and use a common ccdc.c on OMAP/DM644x/AM35xxx. I am not sure if we have any control on how hardware designers name the IP, and would have to deal with it as it happens. For new IPs that is considerably different, but share the same name might have to be named by adding some prefix/suffix as appropriate (example v1, v2 etc for different versions of the same IP, resizer.c for OMAP/DM644x/AM35xxx, resizer_v1.c for resizer on DM355). 

>
>> Myself and Vaibhav had discussed this in the past and ti-media is the
>> generic name that we could agree on. On DM SoCs (DM6446, DM355, DM365) I
>> expect ti-media to be the home for all vpfe and vpbe driver files. Since
>> we had a case of common IP across OMAP and DMxxx SoCs, we want to place
>> all OMAP and DMxxx video driver files in a common directory so that
>> sharing the drivers across the SoCs will be easy. We could discuss and
>> agree on another name if need be. Any suggestions?
>
>It's not the name ti-media that I don't agree on, it's just that this will
>move the problem one step further in the directory hierarchy without
>actually
>solving it :-)
>
>Is it guaranteed today that no TI processors with new generation video
>blocks
>will reuse the names ISP, VPFE and VPBE ? The OMAP3 datasheet refers to
>VPFE
>and VPBE, but luckily those blocks are further divided into subblocks, and
>the
>driver doesn't refer to the VPFE and VPBE directly.
>

As discussed above, we will have to expect name conflicts in future and come up with some naming convention to name files(and add it to v4 documentation). I think this shouldn't prevent this patch from merging to the tree since you are okay with the name. I will send a pull request if you are okay with this
patch.

>--
>Regards,
>
>Laurent Pinchart
