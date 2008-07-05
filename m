Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KFCH8-00027v-Lq
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 20:14:24 +0200
Date: Sat, 5 Jul 2008 11:13:47 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Philipp Hubner <debalance@arcor.de>
In-Reply-To: <486E1D1E.6030403@arcor.de>
MIME-Version: 1.0
Message-ID: <892875.74920.qm@web46103.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy S2 PCI HD
Reply-To: free_beer_for_all@yahoo.com
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

--- On Fri, 7/4/08, Philipp Hu"bner <debalance@arcor.de> wrote:

> scan works now, szap2 works now:
> 
> zapping to 1 'ASTRA SDT':
> sat 0, frequency = 12551 MHz V, symbolrate 22000000, vpid =
> 0x1fff, apid
> = 0x1fff sid = 0x000c
> 
> But mplayer /dev/dvb/adapter0/dvr0 doesn't work:

You should try tuning to a Real Channel[TM]

There is no audio or video on Astra SDT, as you see above --
V+APID == 0x1FFF

I'm sure that later in your .conf file, there are real channels
with real video and audio PIDs just waiting to be tuned into

versuch's mal mit ZDF, u.A...


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
