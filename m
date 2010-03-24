Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab0CXMCT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 08:02:19 -0400
Message-ID: <4BA9FF3E.2090406@redhat.com>
Date: Wed, 24 Mar 2010 09:02:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Resubmit: PATCH-V2] Introducing ti-media directory
References: <hvaibhav@ti.com> <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com> <A69FA2915331DC488A831521EAE36FE4016A785F05@dlee06.ent.ti.com> <201003241005.51075.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201003241005.51075.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Murali,
> 
> On Tuesday 23 March 2010 18:52:44 Karicheri, Muralidharan wrote:
>> Laurent,
>>
>>>> I'm not too sure to like the ti-media name. It will soon get quite
>>>> crowded, and name collisions might occur (look at the linux-omap-camera
>>>> tree and the ISP driver in there for instance). Isn't there an internal
>>>> name to refer to both the DM6446 and AM3517 that could be used ?
>>> [Hiremath, Vaibhav] Laurent,
>>>
>>> ti-media directory is top level directory where we are putting all TI
>>> devices drivers. So having said that, we should worrying about what goes
>>> inside this directory.
>>> For me ISP is more generic, if you compare davinci and OMAP.
>>>
>>> Frankly, there are various naming convention we do have from device to
>>> device, even if the IP's are being reused. For example, the internal name
>>> for OMAP is ISP but Davinci refers it as a VPSS.
>> Could you explain what name space issue you are referring to in
>> linux-omap-camera since I am not quite familiar with that tree?
> 
> The linux-omap-camera tree contains a driver for the OMAP3 ISP. Basically, 
> most source files start with the "isp" prefix and are stored in 
> drivers/media/video/isp/.
> 
> ISP is quite a generic name, and other vendors will probably develop an ISP at 
> some point (if not already done), so there's already a potential name conflict 
> today.
> 
> Using a dedicated directory in drivers/media/video for TI-specific cores is 
> definitely a good idea (assuming the same IP cores won't be used by other 
> vendors in the future).
> 
> My concern is that, if we move the ISP driver in drivers/media/video/ti-media, 
> the directory will soon get quite crowded. If a new TI processor comes up with 
> a totally incompatible ISP, we will get a name conflict in 
> drivers/media/video/ti-media. I was thinking about either replacing the "isp" 
> prefix with "omap3isp" (or similar), or moving the driver to 
> drivers/media/video/ti-media/omap3isp, but that will impede code sharing code 
> between the Davinci and OMAP processor families. That's where my uncertainty 
> comes from.

There are two separate points here. The first one is re-using a driver or some
symbols. Whatever directory structure is used, this won't prevent to share the code.
Just create the header files under include/media and be sure that the Kbuild 
system will properly handle the dependencies, with "depends on".

> 
>> Myself and Vaibhav had discussed this in the past and ti-media is the
>> generic name that we could agree on. On DM SoCs (DM6446, DM355, DM365) I
>> expect ti-media to be the home for all vpfe and vpbe driver files. Since
>> we had a case of common IP across OMAP and DMxxx SoCs, we want to place
>> all OMAP and DMxxx video driver files in a common directory so that
>> sharing the drivers across the SoCs will be easy. We could discuss and
>> agree on another name if need be. Any suggestions?
> 
> It's not the name ti-media that I don't agree on, it's just that this will 
> move the problem one step further in the directory hierarchy without actually 
> solving it :-)
> 
> Is it guaranteed today that no TI processors with new generation video blocks 
> will reuse the names ISP, VPFE and VPBE ? The OMAP3 datasheet refers to VPFE 
> and VPBE, but luckily those blocks are further divided into subblocks, and the 
> driver doesn't refer to the VPFE and VPBE directly.

I agree that a name like ti-media would be too generic. Also, if we take a look on
how the drivers are currently organized, the trees aren't vendor-based, but
chipset-design based. There are even some cases where there's just one or two C files that
are directly stored under drivers/media/video (like tvp5150, for example).

IMO, simpler drivers where just one or a couple of files are needed should be stored
into drivers/media/video. Bigger drivers should be organized by family, and not by vendor. 
Otherwise, we would need to re-organize the tree to be coherent.

One interesting example of the a per-family directory is cx25840. The same driver
is used by several different chipsets. The driver supports a separate IC chip (cx25836,
cx2584x), and two designs where the decoder logic is inside an IC chip with the bridge
and other functional blocks (cx23885 and cx231xx).


-- 

Cheers,
Mauro
