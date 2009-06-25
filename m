Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZFYU1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 16:27:46 -0400
Message-ID: <4A43DDBE.2040804@retrodesignfan.eu>
Date: Thu, 25 Jun 2009 22:27:42 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec DT USB XS Diversity/DiB0070+vdr: "URB status: Value
 too large for defined data type"+USB reset
References: <4A232498.2080202@retrodesignfan.eu> <4A244D3F.8050809@retrodesignfan.eu> <alpine.LRH.1.10.0906021001440.31650@pub3.ifh.de> <4A259186.2040200@retrodesignfan.eu> <alpine.LRH.1.10.0906041005300.6294@pub3.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0906041005300.6294@pub3.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
after I tried a NEC USB-Controller card now using the same 2.6.30-1 
kernel and DVB hardware I can confirm that the problem is the AMD USB 
controller.

Greetings,
Marco

Patrick Boettcher wrote:
> Hi Marco,
>
> On Tue, 2 Jun 2009, Marco Borm wrote:
>>> Definitely interesting. This is a known issue for the dib0700 
>>> device, which happens on some USB host controllers. Actually which 
>>> one do you use?
>>
>> "USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller"
>>
>> Hmm, looks bad: http://www.google.com/search?q=dib0700+sb700
>> But I am wondering if this could really be some bigger linux 
>> USB-stack problem, because it runs with Linux/totem for hours 
>> (mplayer was wrong). For me it looks like vdr uses some feature the 
>> driver doesn't handle correctly. Isn't the EOVERFLOW some local error 
>> value from the usb stack generates if some given buffer was to small?
>
> :(. It is a long story for the SB700 ATI HC ... It turned out for 
> DiBcom that ATI fixed the HC-driver for Windows to make things work 
> correctly.
>
> At some point in time they provided a patch for Linux and it was 
> actually included in 2.6.21 or 22 .
>
> There is some work going on on 2.6.30 for almost similar problems for 
> another device, maybe it is worth to either:
>
> 1) try out latest 2.6.30 releases
> 2) do a (manual) bisect with older kernel to find out which change has 
> made things worse (this is extremely long)
>
>>> Do you connect the device directly to the PC or is there an 
>>> extension cable or another USB hub in between?
>> I tried it with a longer and the short cable which was in the 
>> package, never directly and never with a hub.
>
> Knowing that you have the SB700, I can surely say, it's not the cable, 
> but the controller.
>
> Patrick.
>
> -- 
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

