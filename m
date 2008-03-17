Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JbE9K-0006EB-Hu
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 13:09:09 +0100
Message-ID: <47DE5F42.8070005@iki.fi>
Date: Mon, 17 Mar 2008 14:08:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: insomniac <insomniac@slackware.it>
References: <20080316182618.2e984a46@slackware.it>	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>	<20080317011939.36408857@slackware.it>
	<47DDC4B5.5050607@iki.fi>	<20080317025002.2fee3860@slackware.it>
	<47DDD009.30504@iki.fi>	<20080317025849.49b07428@slackware.it>
	<47DDD817.9020605@iki.fi>	<20080317104147.1ade57fe@slackware.it>	<20080317114802.0df56399@slackware.it>
	<abf3e5070803170409j8be4c54r96f97eb2d3fd4dac@mail.gmail.com>
In-Reply-To: <abf3e5070803170409j8be4c54r96f97eb2d3fd4dac@mail.gmail.com>
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

Jarryd Beck wrote:
> That means the driver either couldn't work out what the tuner is
> and therefore, couldn't attach a frontend, or there was an error
> attaching the frontend. The next job is to work out what the
> tuner chip is, you might have to open it up and read the writing
> off the chip to find that out.

yep, tuner is missing. It could be mt2266. Look other devices in the 
file patched and try if some of those will work.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
