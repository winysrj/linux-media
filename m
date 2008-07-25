Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KMNYz-0000gU-Fe
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 15:42:30 +0200
Message-ID: <4889D841.3010606@iki.fi>
Date: Fri, 25 Jul 2008 16:42:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Simon Baxter <linuxtv@nzbaxters.com>
References: <008401c8ebe5$4e09ea90$450011ac@ad.sytec.com>	<003001c8ecb2$57b93af0$7501010a@ad.sytec.com>
	<003401c8ee3d$7f98b870$7501010a@ad.sytec.com>
In-Reply-To: <003401c8ee3d$7f98b870$7501010a@ad.sytec.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Please - anyone at all?? 682Mhz problem
 with	TT-1501 driver inv4l-dvb
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

Simon Baxter wrote:
> Hi
> I'm getting no responses from any help lists - can anyone offer any advice 
> or comment please???

Could you try to change demodulator parameters slightly to see if it 
helps. There is deltaf ts_output_mode and some other values that could 
effect. Look anysee.c file for example.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
