Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweb5.versatel.de ([82.140.32.141]:56057 "EHLO
	mxweb5.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab2AXSa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 13:30:28 -0500
Received: from cinnamon-sage.de (i577A8E19.versanet.de [87.122.142.25])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id q0OIUNOX006122
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 19:30:24 +0100
Received: from 192.168.23.2:49374 by cinnamon-sage.de for <mchehab@redhat.com>,<chb@muc.de>,<linux-media@vger.kernel.org>,<thomas.schloeter@gmx.net> ; 24.01.2012 19:30:23
Message-ID: <4F1EF8C1.2000508@flensrocker.de>
Date: Tue, 24 Jan 2012 19:30:25 +0100
From: Lars Hanisch <dvb@flensrocker.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Christian Brunner <chb@muc.de>, linux-media@vger.kernel.org,
	thomas.schloeter@gmx.net
Subject: Re: [PATCH] dvb: satellite channel routing (unicable) support
References: <20110928190421.GA13539@sir.fritz.box> <4E837ACF.60804@flensrocker.de> <4F1EAB97.6060301@redhat.com>
In-Reply-To: <4F1EAB97.6060301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 24.01.2012 14:01, schrieb Mauro Carvalho Chehab:
[...]
>>   That would be awesome to have this functionality in the kernel. I maintained the "unicable"-patch for the vdr (written by some guy from the vdr-portal.de who sadly doesn't seem to respond to mails via that forum anymore).
>>   It would be great if all the work could be summarized in one ioctl.
>
> I don't think that SCR/Unicable, bandstacking, LNBf settings, rotor
> control, etc. should belong to the Kernel. There are too many variants,
> and several of them are not properly standardized or properly implemented.
> Also, the actual options to use will depend on what type of DiSEqC components
> used on his particular setup. So, it would be very difficult to write
> something at the Kernel that will fit in all cases.
>
> What the Kernel should support is the capability of sending/receiving DiSEqC
> commands, allowing userspace libraries to do the job of setting it. Such
> feature is already there, so there's no need to change anything there.
>
> That's said, I'm working on a library to be used by applications that want
> to talk with DVB devices. Together, with the library, there are a scanning
> tool and a zapping tool.
>
> So, inspired by this patch, and using a public tech note about SCR/Unicable [1],
> I wrote an Unicable patch for such library:
>
> 	http://git.linuxtv.org/v4l-utils.git/commit/6c2c00ed3722465ed781ad49567e34dc7a5f92e7
>
> I'm currently without DVB-S/DVB-S2 antennas, so, I was not able to test it.
>
> It would be very nice if you could help us by testing if those tools are
> working with DVB-S with SCR, and, if not, help fixing its support.

  Maybe the absence of a good libdvb lead to such patches as the SCR-patch. I understand why such functionality should 
not be in the kernel. Hopefully the libdvb will combine all nice features for dvb hardware so no application has to 
build its own implementations. Another advantage will be that there will be only one place where to configure your 
hardware setup (like SCR, "use only specific delivery system of hybrid cards" etc.).

  I myself have only DVB-C but I know someone with a SCR-setup and will try to convince him to test this.

Thanks,
Lars.

>
> [1] http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/APPLICATION_NOTE/CD00045084.pdf
>
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
