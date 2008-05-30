Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K243O-0006IK-FL
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 14:49:55 +0200
Message-ID: <483FF7CD.2080608@iki.fi>
Date: Fri, 30 May 2008 15:49:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Sigmund Augdal <sigmund@snap.tv>
References: <1212079844.26238.22.camel@rommel.snap.tv>	<483EED5A.7080200@iki.fi>
	<1212138909.26238.34.camel@rommel.snap.tv>
In-Reply-To: <1212138909.26238.34.camel@rommel.snap.tv>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Oops in tda10023
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

Sigmund Augdal wrote:
> tor, 29.05.2008 kl. 20.52 +0300, skrev Antti Palosaari:
>> Sigmund Augdal wrote:
>>> using latest hg v4l-dvb on a 2.6.20 kernel.
>> I did some changes recently to tda10023 (needed for Anysee driver). I 
>> wonder if these errors start coming after that? Those changes are 
>> committed to master only few days ago, 05/26/2008.
> When the crash happened I was using a module with these changes
> included. This doesn't necessarily mean that these changes were the
> cause of the problem. From reading the relevant diff I'd say it's quite
> unlikely that your changes is causing the problem, as tda10023_writereg
> was called from tda10023_attach before also, and you didn't change
> anything in tda10023_writereg it self. I also know for a fact that the
> i2c problems also did happen without your changes, so your changes isn't
> the cause of that either.

Thanks for clarification.

> About your changes to the tda10023 module, I tried these a while ago
> (before they were merged into master, with a technotrend C-1501 board
> that has a tda10023 demod with at tda8274a silicon tuner. I figured the
> tuner had the same deltaf setting as the tuner used in anysee (based on
> how this tuner is used in conjunction with tda10046), but I couldn't
> figure out values for the pll_x parameters. I tried setting them to the
> the same as the ones used in the anysee tree , but I couldn't get any
> lock still, it may however be because my signal was bad at that point.
> If I remember correctly your comments said something about an unknown
> tuner used in the anysee device. Is there any chance it actually is the
> tda827x? As this tuner-demod combo is sold as a refference design from
> phillips.

It could be but I doubt it is not any Philips / NXP tuner PLL.

Every version of the Anysee has Samsung tuner module (or NIM which is 
module with demod inside). In NIMs there is MT532 or ZL10353 
demodulator. DVB-C version has Samsung tuner module + TDA10023 
demodulator on the board. So this is not tuner-demod combo (NIM) 
reference from NXP.

You can resolve correct PLL values looking from USB-sniffs. With a 
little lucky you discover those after some testing.

/* 012 */ 0x28, 0xff, (state->pll_m-1),
/* 015 */ 0x29, 0xff, ((state->pll_p-1)<<6)|(state->pll_n-1),
/* calc sysclk */
state->sysclk = (state->xtal * state->pll_m / \
		(state->pll_n * state->pll_p));

I can try to find those if you can provide usbsniff where those can seen.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
