Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm43.bullet.mail.ne1.yahoo.com ([98.138.120.50]:42899 "EHLO
	nm43.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab3KZT7n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 14:59:43 -0500
References: <1385402616.45186.YahooMailNeo@web162606.mail.bf1.yahoo.com> <5294AE6C.6020105@schinagl.nl>
Message-ID: <1385495819.77730.YahooMailNeo@web162601.mail.bf1.yahoo.com>
Date: Tue, 26 Nov 2013 11:56:59 -0800 (PST)
From: Golden Shadow <firas73737@yahoo.com>
Reply-To: Golden Shadow <firas73737@yahoo.com>
Subject: Re: IPTV Newbie Question/Which Satellite Receiver to Use!
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <5294AE6C.6020105@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Oliver,
Thanks for your reply.
I could not find the PCIe cards you mentioned (L4M-Flex CI or L4M-Flex-Twin C) on the supported PCIe cards on:
http://www.linuxtv.org/wiki/index.php/DVB-C_PCIe_Cards#Supported_DVB-C_PCIe_Cards:


Perhaps it's better to go for a USB device as there are more options to choose from
http://www.linuxtv.org/wiki/index.php/DVB-C_USB_Devices


But still it's not easy to pick the best one that suits a beginner needs.

Best regards,
Firas





On Tuesday, November 26, 2013 5:29 PM, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
On 25-11-13 19:03, Golden Shadow wrote:
> Hello there!
> I am new to IPTV and Video4Linux. I need to implement an IPTV solution that would stream DVB satellite channels in a network. What is the satellite receiver do you recommend me to use on my Linux Centos 6.4 server? The satellite receiver should support encrypted channels. Is it better to use a USB or PCIe receiver? Another question, I'm thinking of using VLC for streaming, do you recommend a better streaming software for my case?
> Thanks a lot,
> Firas
I'm personally very satisfied with linux4media.de devices. If your 
product of choice isn't there, look at digitaldevices.de, same company, 
different frontend. But do buy via linux4media as that counts as a linux 
sale ;)

I personally have the L4M F4mini module (with mini -> pcie adapter 
allowing me potential future options) with currently an L4M-Flex S2. I 
only have 1 for now, but plan to upgrade to 4 laters, giving me 8 tuners 
in single PCI-e slot. Since you say you need crypto, you could use the 
L4M-Flex CI or L4M-Flex-Twin CI module to do that.

Oliver
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

>

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

