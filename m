Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:43364 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab3KZOWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 09:22:25 -0500
Message-ID: <5294AE6C.6020105@schinagl.nl>
Date: Tue, 26 Nov 2013 15:21:32 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Golden Shadow <firas73737@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: IPTV Newbie Question/Which Satellite Receiver to Use!
References: <1385402616.45186.YahooMailNeo@web162606.mail.bf1.yahoo.com>
In-Reply-To: <1385402616.45186.YahooMailNeo@web162606.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

