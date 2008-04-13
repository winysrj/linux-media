Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JkrMJ-0007Hh-Fl
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 03:50:22 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 13 Apr 2008 03:49:14 +0200
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
In-Reply-To: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804130349.15215@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT-Budget C-1501
Reply-To: linux-dvb@linuxtv.org
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

Stephen Dawkins wrote:
> Hi
> 
> I've recently purchased a Technotrend C-1501 card and I've been trying
> to get it to work under Linux.
> 
> I'm not entirely sure what's needed to get it working. I've added the
> following code to drivers/media/dvb/ttpci/budget.c:
> 
> in frontend_init:
>    case 0x101a: // TT Budget-C-1501 (philips tda10023/philips tda8274A)
>        budget->dvb_frontend = dvb_attach(tda10023_attach,
> &tda1002x_config, &budget->i2c_adap, read_pwm(budget));
>        if (budget->dvb_frontend) {
>           if (dvb_attach(tda827x_attach, budget->dvb_frontend, 0x0e,
> &budget->i2c_adap, 0) == NULL)
                    ^^^
I don't know, but maybe you have to pass a config struct for the tda827x
driver here.

>              printk("%s: No tda827x found!\n", __FUNCTION__);
>           break;
>        }
>     }
> 
> and the relevant MAKE_BUDGET_INFO and MAKE_EXTENTION_PCI entries. I'm
> not entirely sure, but I think the demodulator is on 0x0c on the i2c bus
> and the tuner is on 0x0e, is there a way of confirming this?

The tuner address sounds strange to me. If the tuner is not behind an
i2c gate, you should be able to find it by running i2cdetect (from the
i2c tools package).

> When I modprobe budget, I get the follow:
> 
> saa7146: register extension 'budget dvb'.
> ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 (level, low) -> IRQ 17
> saa7146: found saa7146 @ mem f8de2000 (revision 1, irq 17) (0x13c2,0x101a).
> budget: budget_attach(): dev:f7281580, info:f8df5c20, budget:f7173000
> budget_core: ttpci_budget_init(): dev: f7281580, budget: f7173000
> budget_core: ttpci_budget_init(): saa7146 (0): buffer type = single,
> width = 188, height = 1024
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-budget-C-1501)
> adapter has MAC addr = 00:d0:5c:c6:4f:01
> budget_core: budget_register(): budget: f7173000
> DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
> 
> I also get demux0, dvr0, frontend0 and net0 in /dev/dvb0.
> 
> I then do a dvbtune -f 666750000 -s 6952, and I get:
> 
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> 
> I'm not entirely sure what I need todo next to get it working, any help
> will be greatly appreciated.

See m920x.c or saa7134-dvb.c for drivers using tda10046 and/or tda827x.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
