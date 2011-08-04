Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab1HDXnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 19:43:51 -0400
Message-ID: <4E3B2EB3.6030501@iki.fi>
Date: Fri, 05 Aug 2011 02:43:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de>	 <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net>	 <4DFFC82B.10402@iki.fi> <1308649292.3635.2.camel@maxim-laptop> <4E006BDB.8060000@hoogenraad.net> <4E17CA94.8030307@iki.fi>
In-Reply-To: <4E17CA94.8030307@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have done some updates. MXL5005S based RTL2831U devices didn't worked
due to bug. That's main visible change. Secondly I added basic support
for RTL2832U to rtl28xx driver. And implemented I2C as I see it really
is, I think it is almost perfect now. It works fine my RTL2832U device
with stubbed demod and tuner drivers.

Next weeks I will hack most likely Anysee, but when I feel bored of
Anysee, I will switch back to rtl28xx driver :p

regards
Antti


On 07/09/2011 06:27 AM, Antti Palosaari wrote:
> Hello
> RTL2831U driver is now available here "realtek" branch:
> http://git.linuxtv.org/anttip/media_tree.git
> 
> From my side it is ready for merge.
> 
> RTL2830 DVB-T demod
> ===================
> Driver is very limited, it basically just works, no any statistics.
> That's written totally from the scratch.
> 
> RTL28XXU DVB USB
> ================
> I think it is also almost fully written from the scratch, but not sure
> since it have been so loooong under the development. At least register
> definitions are from Realtek driver. Jan could you now find out
> copyrights, SOBs, etc. are correct? And how that should be merge...
> 
> I wonder Maxim can add support for RTL2832U to RTL28XXU DVB USB. It
> should not be much work. I tested it with my RTL2832U device and some
> minor changes were needed. Remote controller seems to be only which is
> totally different between RTL2831U and RTL2832U (and later).
> 
> 
> regards
> Antti
> 


-- 
http://palosaari.fi/
