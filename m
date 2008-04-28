Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JqHUY-0008DN-Vq
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 02:45:15 +0200
From: Andy Walls <awalls@radix.net>
To: Andreas <linuxdreas@launchnet.com>
In-Reply-To: <200804271649.09000.linuxdreas@launchnet.com>
References: <200804271649.09000.linuxdreas@launchnet.com>
Date: Sun, 27 Apr 2008 20:45:01 -0400
Message-Id: <1209343501.3208.17.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 driver not in main repo?
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

On Sun, 2008-04-27 at 16:49 -0700, Andreas wrote:
> Hi all,
> I noticed today that the cx18 driver (for Hauppauge's HVR-1600) is not in 
> the main v4ldvb repository.

Andreas,

Hans just asked Mauro to pull it.  See:

http://ivtvdriver.org/pipermail/ivtv-devel/2008-April/005509.html


>  I was hoping to take advantage of the new 
> module parameter "adapter_nr" for my other dvb card (using the saa7134_dvb 
> driver) to achieve a consistent device numbering across restarts. Instead, 
> I had to check out Hans Verkuil's repo with the cx18, but without the new 
> module parameter.

The latest of Hans' cx18 repo does have the parameter in question.  From
my hg cloned copy:

$ grep -n adapter_nr cx18/linux/drivers/media/video/cx18/*
cx18/linux/drivers/media/video/cx18/cx18-dvb.c:29:DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
cx18/linux/drivers/media/video/cx18/cx18-dvb.c:144:                     THIS_MODULE, &cx->dev->dev, adapter_nr);

Beyond "/sbin/modinfo cx18" I can't test if it works.  But if you need
it, it's there.

Regards,
Andy

> 
> Is there a reason why the cx18 driver is not available in the main repo?
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
