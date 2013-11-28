Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:42020 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3K1L1h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Nov 2013 06:27:37 -0500
Message-ID: <5297286A.5020809@schinagl.nl>
Date: Thu, 28 Nov 2013 12:26:34 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Golden Shadow <firas73737@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: IPTV Newbie Question/Which Satellite Receiver to Use!
References: <1385402616.45186.YahooMailNeo@web162606.mail.bf1.yahoo.com> <5294AE6C.6020105@schinagl.nl> <1385495819.77730.YahooMailNeo@web162601.mail.bf1.yahoo.com>
In-Reply-To: <1385495819.77730.YahooMailNeo@web162601.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26-11-13 20:56, Golden Shadow wrote:
> Hello Oliver,
> Thanks for your reply.
> I could not find the PCIe cards you mentioned (L4M-Flex CI or L4M-Flex-Twin C) on the supported PCIe cards on:
> http://www.linuxtv.org/wiki/index.php/DVB-C_PCIe_Cards#Supported_DVB-C_PCIe_Cards:

The two drivers for all their cards, based on generation you have the 
ngene and the ddbridge driver.

If you search for ddbrige on the wiki you'll find what you seek.

http://linuxtv.org/wiki/index.php/Linux4Media_cineS2_DVB-S2_Twin_Tuner

try that page (though I had to type it, couldn't copy paste).

That's info about the drivers in general for their cards, Sinds you 
mention DVB-C now, I thought you said dvb-s before, you'd have to look 
at the C&T devices, the wikipage dedicated to the C&T devices is

http://linuxtv.org/wiki/index.php/Digital_Devices_DuoFlex_C%26T

Same base card, different tuners, same driver. Search for ddbridge and 
you will find all you may need to know.
>
>
> Perhaps it's better to go for a USB device as there are more options to choose from
> http://www.linuxtv.org/wiki/index.php/DVB-C_USB_Devices
I strongly prefer PCI(e) based cards over USB, especially for permanent 
installations, but to each his own.

Oliver
>
>
> But still it's not easy to pick the best one that suits a beginner needs.
>
> Best regards,
> Firas
>
>
>
>
>
> On Tuesday, November 26, 2013 5:29 PM, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
> On 25-11-13 19:03, Golden Shadow wrote:
>> Hello there!
>> I am new to IPTV and Video4Linux. I need to implement an IPTV solution that would stream DVB satellite channels in a network. What is the satellite receiver do you recommend me to use on my Linux Centos 6.4 server? The satellite receiver should support encrypted channels. Is it better to use a USB or PCIe receiver? Another question, I'm thinking of using VLC for streaming, do you recommend a better streaming software for my case?
>> Thanks a lot,
>> Firas
> I'm personally very satisfied with linux4media.de devices. If your
> product of choice isn't there, look at digitaldevices.de, same company,
> different frontend. But do buy via linux4media as that counts as a linux
> sale ;)
>
> I personally have the L4M F4mini module (with mini -> pcie adapter
> allowing me potential future options) with currently an L4M-Flex S2. I
> only have 1 for now, but plan to upgrade to 4 laters, giving me 8 tuners
> in single PCI-e slot. Since you say you need crypto, you could use the
> L4M-Flex CI or L4M-Flex-Twin CI module to do that.
>
> Oliver
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

