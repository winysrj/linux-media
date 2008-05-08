Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from astana.suomi.net ([82.128.152.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Ju8At-0003uq-Tx
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 17:36:52 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by astana.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0K00CZP3CI5KA0@astana.suomi.net> for
	linux-dvb@linuxtv.org; Thu, 08 May 2008 18:36:18 +0300 (EEST)
Received: from spam5.suomi.net (spam5.suomi.net [212.50.131.165])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0K00H243CIDQ80@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Thu, 08 May 2008 18:36:18 +0300 (EEST)
Date: Thu, 08 May 2008 18:35:20 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <200805082312.59928.b87605214@ntu.edu.tw>
To: lin <b87605214@ntu.edu.tw>
Message-id: <48231DB8.4050101@iki.fi>
MIME-version: 1.0
References: <200805071307.15982.b87605214@ntu.edu.tw>
	<48219F49.9090709@Rods.id.au> <200805082312.59928.b87605214@ntu.edu.tw>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Try to Make DVB-T part of Compro VideoMate T750 Work
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

lin wrote:
> +static struct zl10353_config videomate_t750_zl10353_config = {
> 
> + .demod_address = 0x0f,
> 
> + .no_tuner = 0,
> 
> + .parallel_ts = 1,
> 
> +};
> 
> +
> 
> +static struct qt1010_config videomate_t750_qt1010_config = {
> 
> + .i2c_address = 0x62
> 
> +};

For QT1010 (and other silicon tuners as well) ZL10353 configuration 
no_tuner should be 1. It can be zero when there is simple "4-byte" PLL 
tuner connected directly to ZL10353 demodulator and demodulator programs 
tuner.
See following scheme for explanation:
http://www.otit.fi/~crope/v4l-dvb/controlling_tuner.txt

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
