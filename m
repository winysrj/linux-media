Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZFBUye (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 16:54:34 -0400
Message-ID: <4A259186.2040200@retrodesignfan.eu>
Date: Tue, 02 Jun 2009 22:54:30 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec DT USB XS Diversity/DiB0070+vdr: "URB status: Value
 too large for defined data type"+USB reset
References: <4A232498.2080202@retrodesignfan.eu> <4A244D3F.8050809@retrodesignfan.eu> <alpine.LRH.1.10.0906021001440.31650@pub3.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0906021001440.31650@pub3.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

thanks for response.

Patrick Boettcher wrote:
> Hi Marco,
>
>>> [...]This logs aren't very helpful, but I find something interesting 
>>> with Wireshark and usbmon:
>>> device -> host
>>> URB type: URB_COMPLETE ('C')
>>> URB transfer type: URB_BULK (3)
>>> [...]
>>> URB status: Value too large for defined data type (-EOVERFLOW) (-75)
>>> [...]
>>>
>>> after this URB I get a "URB transfer type: URB_INTERRUPT (1)" and 
>>> all goes to hell.
>>>
>>> Its also  interesting that the URB+data length in the failure 
>>> package is 39424 but "URB length [bytes]: 39480" in every package 
>>> before that.
>
> Definitely interesting. This is a known issue for the dib0700 device, 
> which happens on some USB host controllers. Actually which one do you 
> use?
"USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller"
Hmm, looks bad: http://www.google.com/search?q=dib0700+sb700
But I am wondering if this could really be some bigger linux USB-stack 
problem, because it runs with Linux/totem for hours (mplayer was wrong). 
For me it looks like vdr uses some feature the driver doesn't handle 
correctly. Isn't the EOVERFLOW some local error value from the usb stack 
generates if some given buffer was to small?

>
>>> As I know this device works without problems under linux for other 
>>> people, so I'm wondering why. I searched but found nothing about 
>>> such a problem.
>
> Yeah, but are they using 2.6.29?
I don't know.
>
> In fact, since 2 days I'm having the T5 Terratec device, which seems 
> to be similar to your device, I'm going to try it soon. To experience 
> whether there are similar problems.
>
> Do you connect the device directly to the PC or is there an extension 
> cable or another USB hub in between?
I tried it with a longer and the short cable which was in the package, 
never directly and never with a hub.


Marco
