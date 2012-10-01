Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:57661 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752841Ab2JANFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 09:05:16 -0400
Message-ID: <5069958E.3090407@gmx.net>
Date: Mon, 01 Oct 2012 15:07:26 +0200
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: Integrate camera interface of OMAP3530 in Angstrom Linux
References: <5048E4A4.40901@gmx.net> <1545584.uHsE0d20W1@avalon>
In-Reply-To: <1545584.uHsE0d20W1@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thanks for your reply.

Using a current mainline kernel is a little problematic. Recently I 
compiled the 2.6.39 and it wasn't able to boot at all. The reason for 
this are probably the chips, that are built on the CPU module. Usually, 
a working kernel for this module was undergoing some modifications by 
Technexion because of these chips.
Currently, Technexion only offers the 2.6.32. and 2.6.37 kernel. The 
latter one makes a new device node /dev/media0 available (after 
activating some 'experimental' marked options in the kernel config), but 
I wasn't able to capture any signal.

I'm going to try the latest mainline kernel, but I doubt it will work.

Kind regards,
Andreas


Am 26.09.2012 13:41, schrieb Laurent Pinchart:
> Hi Andreas,
>
> On Thursday 06 September 2012 20:00:04 Andreas Nagel wrote:
>> Hello,
>>
>> I am using an embedded module called TAO-3530 from Technexion, which has
>> an OMAP3530 processor.
>> This processor has a camera interface, which is part of the ISP
>> submodule. For an ongoing project I want to capture a video signal from
>> this interface. After several days of excessive research I still don't
>> know, how to access it.
>> I configured the Angstrom kernel (2.6.32), so that the driver for OMAP 3
>> camera controller (and all other OMAP 3 related things) is integrated,
>> but I don't see any new device nodes in the filesystem.
> You should upgrade to a much more recent kernel, as the driver for the OMAP3
> ISP included in the Angstrom 2.6.32 kernel is just bad legacy code that should
> be burried in a very deep cave.
>
>> I also found some rumors, that the Media Controller Framework or driver
>> provides the device node /dev/media0, but I was not able to install it.
> You will need to upgrade your kernel for that. I'd advise going for the latest
> mainline kernel.
>
>> I use OpenEmbedded, but I don't have a recipe for Media Controller. On
>> the Angstrom website ( http://www.angstrom-distribution.org/repo/ )
>> there's actually a package called "media-ctl", but due to the missing
>> recipe, i can't install it. Can't say, I am an expert in OE.
>>
>> Can you help me point out, what's necessary to make the camera interface
>> accessible?

