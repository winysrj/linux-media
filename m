Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server30.ukservers.net ([217.10.138.207])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1K7c34-0004Vd-2W
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 22:08:30 +0200
Message-ID: <09e001c8ce5a$558b9a50$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: "Arthur Konovalov" <artlov@gmail.com>,
	<linux-dvb@linuxtv.org>
References: <1212585271.32385.41.camel@pascal>	<1212590233.15236.11.camel@rommel.snap.tv>	<1212657011.32385.53.camel@pascal><200806081738.20609@orion.escape-edv.de>
	<484CBDF3.90806@gmail.com>
Date: Sun, 15 Jun 2008 08:07:53 +1200
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

Hi

What am I doing wrong - sorry for the potentially idiot error...

I got what I thought was the latest, which would include these c-1501 
patches yes??
hg clone http://linuxtv.org/hg/v4l-dvb


But there's no "linux/drivers/media/dvb/frontends/tda827x.c"   and the 
"linux/drivers/media/dvb/ttpci/budget-ci.c"   is not the same as the patches 
references.

[root@freddy v4l-dvb]# find . | grep tda827x.c
./.hg/store/data/linux/drivers/media/common/tuners/tda827x.c.i
./.hg/store/data/linux/drivers/media/dvb/frontends/tda827x.c.i
./linux/drivers/media/common/tuners/tda827x.c


Have I got the wrong repository??




----- Original Message ----- 
From: "Arthur Konovalov" <artlov@gmail.com>
To: <linux-dvb@linuxtv.org>
Sent: Monday, June 09, 2008 5:21 PM
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501


> Oliver Endriss wrote:
>> Sigmund Augdal wrote:
>>> Here is a new version. This one passes checkpatch without warnings. I
>>> removed the read_pwm function, as it always uses the fallback path for
>>> my card (and frankly I have no idea wether it is actually relevant at
>>> all for this kind of card). Furthermore the tda10023 driver doesn't seem
>>> to use this value for anything.
>>
>> Any issues with this patch? If not I will commit it next weekend.
>
> At the first glance it works fine, thanks Sigmund.
> Although for multiproto drivers I slightly modified patches and replaced 
> some
> files from linux-dvb tree (tda10021.c, tda10023.c, tda1002x.h).
>
> However, I don't know how necessary is tda827x-oops patch with multiproto.
>
> At compile have only one warning:
>   CC [M]  /usr/local/src/multiproto-2008-05-14/v4l/budget-av.o
> /usr/local/src/multiproto-2008-05-14/v4l/budget-av.c: In function 
> 'frontend_init':
> /usr/local/src/multiproto-2008-05-14/v4l/budget-av.c:1306: warning: 
> passing
> argument 1 of '__a' from incompatible pointer type
>
>
> Regards,
> AK
>


--------------------------------------------------------------------------------


> --- linux/drivers/media/dvb/frontends/tda827x.c.old 2008-06-06 
> 13:57:57.000000000 +0300
> +++ linux/drivers/media/dvb/frontends/tda827x.c 2008-06-06 
> 13:59:52.000000000 +0300
> @@ -554,7 +554,7 @@
>  struct tda827x_priv *priv = fe->tuner_priv;
>  unsigned char buf[] = {0x22, 0x01};
>  int arg;
> - struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
> + struct i2c_msg msg = { .flags = 0,
>         .buf = buf, .len = sizeof(buf) };
>
>  if (NULL == priv->cfg) {
> @@ -562,6 +562,7 @@
>  return;
>  }
>
> + msg.addr = priv->i2c_addr;
>  if (priv->cfg->config) {
>  if (high)
>  dprintk("setting LNA to high gain\n");
>


--------------------------------------------------------------------------------


> --- linux/drivers/media/dvb/ttpci/budget-ci.c.old 2008-06-06 
> 13:39:23.000000000 +0300
> +++ linux/drivers/media/dvb/ttpci/budget-ci.c 2008-06-06 
> 13:50:18.000000000 +0300
> @@ -51,6 +51,8 @@
> #include "lnbp21.h"
> #include "bsbe1.h"
> #include "bsru6.h"
> +#include "tda1002x.h"
> +#include "tda827x.h"
>
> /*
>  * Regarding DEBIADDR_IR:
> @@ -1337,6 +1339,16 @@
>  .refclock = 27000000,
> };
>
> +static struct tda10023_config tda10023_config = {
> + .demod_address = 0xc,
> + .invert = 0,
> + .xtal = 16000000,
> + .pll_m = 11,
> + .pll_p = 3,
> + .pll_n = 1,
> + .deltaf = 0xA511,
> +};
> +
> static void frontend_init(struct budget_ci *budget_ci)
> {
>  switch (budget_ci->budget.dev->pci->subsystem_device) {
> @@ -1404,7 +1416,20 @@
>  budget_ci->budget.dvb_frontend = NULL;
>  }
>  }
> -
> + break;
> + case 0x101a: /* TT Budget-C-1501 (philips tda10023/philips tda8274A) */
> + budget_ci->budget.dvb_frontend =
> + dvb_attach(tda10023_attach, &tda10023_config,
> +    &budget_ci->budget.i2c_adap, 0x48);
> + if (budget_ci->budget.dvb_frontend) {
> + if (dvb_attach(tda827x_attach,
> +        budget_ci->budget.dvb_frontend, 0x61,
> +        &budget_ci->budget.i2c_adap, NULL)
> +     == NULL)
> + printk(KERN_ERR "%s: No tda827x found!\n",
> +        __func__);
> + break;
> + }
>  break;
>
>  case 0x1019: // TT S2-3200 PCI
> @@ -1535,6 +1560,7 @@
> MAKE_BUDGET_INFO(ttbtci, "TT-Budget-T-CI PCI", BUDGET_TT);
> MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
> MAKE_BUDGET_INFO(tt3200, "TT-Budget S2-3200 PCI", BUDGET_TT);
> +MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
>
> static struct pci_device_id pci_tbl[] = {
>  MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
> @@ -1544,6 +1570,7 @@
>  MAKE_EXTENSION_PCI(ttbtci, 0x13c2, 0x1012),
>  MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
>  MAKE_EXTENSION_PCI(tt3200, 0x13c2, 0x1019),
> + MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101A),
>  {
>  .vendor = 0,
>  }
>


--------------------------------------------------------------------------------


> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
