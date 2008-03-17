Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jb3rF-0001pn-NJ
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 02:09:46 +0100
Message-ID: <47DDC4B5.5050607@iki.fi>
Date: Mon, 17 Mar 2008 03:09:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: insomniac <insomniac@slackware.it>
References: <20080316182618.2e984a46@slackware.it>	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
	<20080317011939.36408857@slackware.it>
In-Reply-To: <20080317011939.36408857@slackware.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

insomniac wrote:
>> The best way you can help is to either tell us what the windows
>> drivers are, or open the device up and tell us what is written on
>> both the tuner chip and the main chip. They are generally the two
>> biggest chips on the board and they have writing on the top.
>>
>> Jarryd.
> 
> I'm not sure about how to give you correct and detailed informations, as
> I'm not a Windows user, so correct me if I'm wrong. I cheched for driver
> details on Windows, and I see the following files:
> 
> BdaPlgIn.ax
> drivers\BdaSup.sys
> drivers\mod7700.sys

[..]

> Tell me if you need more information, I'm very interested into make my
> card work and give back to the community all the support I can.

Look driver .inf files, they usually reveals better information. Anyhow, 
mod7700 could be DibCom 7700 chipset that is supported rather well.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
