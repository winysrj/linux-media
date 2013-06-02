Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49620 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3FBVNd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 17:13:33 -0400
Message-ID: <51ABB553.702@iki.fi>
Date: Mon, 03 Jun 2013 00:12:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Torsten Seyffarth <t.seyffarth@gmx.de>
CC: poma <pomidorabelisima@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Cinergy TStick RC rev.3 (rtl2832u) only 4 programs
References: <51A73A88.9000601@gmx.de> <51A76FCA.3010803@gmail.com> <51A78CA5.5040502@gmx.de> <51A7AD71.4010403@gmail.com> <51AA00DD.4020201@gmx.de>
In-Reply-To: <51AA00DD.4020201@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2013 05:10 PM, Torsten Seyffarth wrote:
>
> Am 30.05.2013 21:50, schrieb poma:
>> You've used the original driver provided by Realtek, 'dvb-usb-rtl2832'.
>> You are currently using GPL'd, 'dvb_usb_v2', 'dvb_usb_rtl28xxu' and
>> 'e4000' designed by Antti & Thomas.
>>
>
> So I will try to find another useful option for this stick.
> How do I prevent similar problems with the next stick I buy?

It is most likely e4000 bug. Some corner case. It is surely very easy to 
find out, will take only 1-2 hours or so when you could reproduce it and 
you know what to do.

Just take USB sniffs from working configuration, generate tuner register 
write code and copy & paste that to the tuner driver until it starts 
working. After that you could find out problematic registers quite seen 
just trial and error method.

Lastly someone sends me non-working rtl2832u + e4000 device. I put just 
same transmission parameters, which was said non-working, to my 
modulator and it worked! Likely signal got from modulator was so perfect 
that I was unable to reproduce issue.

Best thing what you could to is just to jump in and start fixing these 
drivers yourself. There is only very few person who do these nowadays. 
It is just lack of developers!

regards
Antti

-- 
http://palosaari.fi/
