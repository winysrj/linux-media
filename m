Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:51672 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0GBEUe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 00:20:34 -0400
Message-ID: <4C2D68FA.6010603@vorgon.com>
Date: Thu, 01 Jul 2010 21:20:10 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: laggy remote on x64
References: <4C2A87A4.1090104@vorgon.com>
In-Reply-To: <4C2A87A4.1090104@vorgon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have now noticed that IR drivers are being loaded when I modprobe 
cx23885 to load the drivers for the HVR-1800 which doesn't even have a 
remote. The 32bit computer doesn't have this card, it has a Nexus and a 
FusionHDTV7 express. The drivers that are being loaded seem to be enough 
to get a responce from the nexus remote, but it's doing exactly the same 
thing as when I also modprobe ir_kbd_i2c which was always used in the 
past to load remote drivers for the nexus and is what I have been using 
to load drivers for the Fusion card. Is there some kind of conflict now? 
I've had the 1800 in the x64 system with the nexus for a long time but 
stopped using/updating it to get the 32bit system running. There seems 
to be a problem with the new IR drivers.

On 6/29/2010 4:54 PM, Timothy D. Lenz wrote:
> I have 2 systems nearly identical except one runs 64bit and the other
> runs 32bit. I'm now trying to use the remote port on the nexus-s card.
> The 32 bit seems to be working ok, but the 64bit acts like it's bussy
> doing somthing else. It randomly won't respond to the remote. It doesn't
> buffer the keys or anything. Wait a moment and maybe it works fine for a
> few presses. When it doesn't respond is highly random. Kernel-2.6.34,
> debian squeeze updated a few days ago, v4l is hg from 06/25/2010
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
