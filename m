Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6c98a8984fcc4e30f0b1+1756+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K7UQ9-0005I0-IZ
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 13:59:49 +0200
Date: Sat, 14 Jun 2008 08:58:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080614085834.0d0baf41@gaivota>
In-Reply-To: <484D20F3.6030004@iinet.net.au>
References: <48498964.10301@iinet.net.au>
	<1212785950.16279.17.camel@pc10.localdom.local>
	<20080606183617.5c2b6398@gaivota> <484A1441.6070400@iinet.net.au>
	<484A1FC7.6070707@iinet.net.au>
	<1212886803.25974.44.camel@pc10.localdom.local>
	<20080608073836.233e801a@gaivota> <484C9E0A.1030909@iinet.net.au>
	<484D19B5.2060201@iinet.net.au> <484D20F3.6030004@iinet.net.au>
Mime-Version: 1.0
Cc: hartmut.hackmann@t-online.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with latest v4l-dvb hg
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

Hi Tim,

I'm not sure if it is the same bug, but, on a device I have with tda10046, I
need to slow firmware load, otherwise, it will fail. This happens on an AMD 64
dual core notebook @1.8GHz. The same board, on an Intel single core @1.1GHz
works without troubles.

Please test the enclosed patch.

On Mon, 09 Jun 2008 20:24:19 +0800
timf <timf@iinet.net.au> wrote:

> > [   38.194402] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> > [   38.286214] tda829x 2-004b: setting tuner address to 61
> > [   38.370076] tda829x 2-004b: type set to tda8290+75a
> > [   42.195417] saa7133[0]: registered device video0 [v4l2]
> > [   42.195437] saa7133[0]: registered device vbi0
> > [   42.195461] saa7133[0]: registered device radio0
> > [   42.355808] DVB: registering new adapter (saa7133[0])
> > [   42.355815] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> > [   42.427655] tda1004x: setting up plls for 48MHz sampling clock
> > [   44.678388] tda1004x: timeout waiting for DSP ready
> > [   44.718322] tda1004x: found firmware revision 0 -- invalid
> > [   44.718326] tda1004x: trying to boot from eeprom


diff -r 000ffc33cb89 linux/drivers/media/dvb/frontends/tda1004x.c
--- a/linux/drivers/media/dvb/frontends/tda1004x.c	Sat Jun 14 08:27:34 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda1004x.c	Sat Jun 14 08:53:01 2008 -0300
@@ -135,6 +135,9 @@
 
 	msg.addr = state->config->demod_address;
 	ret = i2c_transfer(state->i2c, &msg, 1);
+
+	if (state->config->xtal_freq == TDA10046_XTAL_16M)
+		msleep(1);
 
 	if (ret != 1)
 		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",



Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
