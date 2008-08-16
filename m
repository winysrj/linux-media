Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KUDUg-0006Rx-1q
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 06:34:39 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 16 Aug 2008 05:54:18 +0200
References: <341e26050808101001x6ba9c5f2i5bc48b7008d5f232@mail.gmail.com>
	<341e26050808131435m8970a05x1145075eaff0514d@mail.gmail.com>
	<341e26050808140027p49da3ce6o3e705125d396d3db@mail.gmail.com>
In-Reply-To: <341e26050808140027p49da3ce6o3e705125d396d3db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_q9kpIjwJ3nZZNlB"
Message-Id: <200808160554.18844@orion.escape-edv.de>
Subject: Re: [linux-dvb] activy dvb-t ALPS tdhd1-204A support?
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_q9kpIjwJ3nZZNlB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

webmaster lunastick wrote:
> On Thu, Aug 14, 2008 at 12:35 AM, webmaster lunastick
> <lunastick@gmail.com> wrote:
> > Hi,
> >
> > On Mon, Aug 11, 2008 at 5:09 AM, Oliver Endriss <o.endriss@gmx.de> wrote:
> >> webmaster lunastick wrote:
> >>> Hi,
> >>>
> >>> I have also a AMC 570 with 2 dvb-t tuners. (activy dvb-t model
> >>> S26361-D1297-V300 GS2)
> >>> (Pcb has a print: ActivyAL BS 03601790A)
> >>> The chip is SAA7146AH. I opened the tuner tin box
> >>> and only chip that was visible was Epcos X7251D
> >>
> >> There should be more chips inside, maybe on the other side of the pcb.
> >> Which chips are outside of the tin box?
> >> Could you provide a hires picture of the board?
> >>
> > I should desolder the tuner to see chips on the other side of the pcb
> > and I don,t
> > want take the risk of breaking my tuner. However, I searched trough the
> > original windows .inf files and found this comment in a file that installs
> > right tuner settings
> >
> >  8: Siemens Alps-T TDHD1
> >   ;    DVB-T Tuner with
> >   ;    TDA10046 COFDM Demodulator
> >
> > So it seems that now we know the demodulator.
> > Do we still need to know what tuner is in use?
> >
> TDM1316 is a good guess but it could be any other pll too... :(
>  Do you think that I could be possible
> to test the card with TDA1004x driver and see if it works?

Ok, I created a patch based on the information in the TDHD1 datasheet.

Unfortunately the information is far from complete, so I am not sure
whether we can produce a working driver without further information.

Please try the attached patch.

Note that the tda10046 requires external firmware which can be downloaded
and extracted using
  <kerneldir>/Documentation/dvb/get_dvb_firmware tda10046

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_q9kpIjwJ3nZZNlB
Content-Type: text/x-diff;
  charset="us-ascii";
  name="activy-tdhd1-test1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="activy-tdhd1-test1.diff"

diff -r cbfa05ad2711 linux/drivers/media/dvb/ttpci/Kconfig
--- a/linux/drivers/media/dvb/ttpci/Kconfig	Fri Aug 01 08:23:41 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/Kconfig	Sat Aug 16 05:50:13 2008 +0200
@@ -86,6 +86,7 @@ config DVB_BUDGET
 	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
 	select DVB_TDA826X if !DVB_FE_CUSTOMISE
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
+	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
 	help
 	  Support for simple SAA7146 based DVB cards (so called Budget-
 	  or Nova-PCI cards) without onboard MPEG2 decoder, and without
diff -r cbfa05ad2711 linux/drivers/media/dvb/ttpci/budget.c
--- a/linux/drivers/media/dvb/ttpci/budget.c	Fri Aug 01 08:23:41 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget.c	Sat Aug 16 05:50:13 2008 +0200
@@ -46,6 +46,7 @@
 #include "lnbp21.h"
 #include "bsru6.h"
 #include "bsbe1.h"
+#include "tda1004x.h"
 
 static int diseqc_method;
 module_param(diseqc_method, int, 0444);
@@ -390,6 +391,60 @@ static struct stv0299_config alps_bsbe1_
 };
 
 
+/* ALPS TDHD1-204
+   This frontends requires external firmware. Please use the command
+       "<kerneldir>/Documentation/dvb/get_dvb_firmware tda10046"
+   to download/extract it, and then copy it to /usr/lib/hotplug/firmware
+   or /lib/firmware (depending on configuration of firmware hotplug).
+*/
+static int alps_tdhd1_204_request_firmware(struct dvb_frontend *fe, const struct firmware **fw, char *name)
+{
+	struct budget *budget = (struct budget *)fe->dvb->priv;
+
+	return request_firmware(fw, name, &budget->dev->pci->dev);
+}
+
+static struct tda1004x_config alps_tdhd1_204_config = {
+	.demod_address = 0x8,
+	.invert = 1,
+	.invert_oclk = 0,
+	.xtal_freq = TDA10046_XTAL_4M,
+	.agc_config = TDA10046_AGC_DEFAULT,
+	.if_freq = TDA10046_FREQ_3617,
+	.request_firmware = alps_tdhd1_204_request_firmware,
+};
+
+static int alps_tdhd1_204_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+{
+	struct budget *budget = fe->dvb->priv;
+	u8 data[4];
+	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
+	u32 div;
+
+	div = (params->frequency + 36166666) / 166666;
+
+	data[0] = (div >> 8) & 0x7f;
+	data[1] = div & 0xff;
+	data[2] = 0x85;
+
+	if (params->frequency >= 174000000 && params->frequency <= 230000000)
+		data[3] = 0x02;
+	else if (params->frequency >= 470000000 && params->frequency <= 823000000)
+		data[3] = 0x0C;
+	else if (params->frequency >= 824000000 && params->frequency <= 862000000)
+		data[3] = 0x8C;
+	else
+		return -EINVAL;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (i2c_transfer(&budget->i2c_adap, &msg, 1) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+
 static int i2c_readreg(struct i2c_adapter *i2c, u8 adr, u8 reg)
 {
 	u8 val;
@@ -510,6 +565,12 @@ static void frontend_init(struct budget 
 		}
 		break;
 
+	case 0x5f60: /* Fujitsu Siemens Activy Budget-T PCI rev AL (tda10046/ALPS TDHD1-204) */
+		budget->dvb_frontend = dvb_attach(tda10046_attach, &alps_tdhd1_204_config, &budget->i2c_adap);
+		if (budget->dvb_frontend)
+			budget->dvb_frontend->ops.tuner_ops.set_params = alps_tdhd1_204_tuner_set_params;
+		break;
+
 	case 0x5f61: /* Fujitsu Siemens Activy Budget-T PCI rev GR (L64781/Grundig 29504-401(tsa5060)) */
 		budget->dvb_frontend = dvb_attach(l64781_attach, &grundig_29504_401_config_activy, &budget->i2c_adap);
 		if (budget->dvb_frontend) {
@@ -623,6 +684,7 @@ MAKE_BUDGET_INFO(fsacs0, "Fujitsu Siemen
 MAKE_BUDGET_INFO(fsacs0, "Fujitsu Siemens Activy Budget-S PCI (rev GR/grundig frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsacs1, "Fujitsu Siemens Activy Budget-S PCI (rev AL/alps frontend)", BUDGET_FS_ACTIVY);
 MAKE_BUDGET_INFO(fsact,	 "Fujitsu Siemens Activy Budget-T PCI (rev GR/Grundig frontend)", BUDGET_FS_ACTIVY);
+MAKE_BUDGET_INFO(fsact1, "Fujitsu Siemens Activy Budget-T PCI (rev AL/ALPS frontend)", BUDGET_FS_ACTIVY);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbs,  0x13c2, 0x1003),
@@ -633,6 +695,7 @@ static struct pci_device_id pci_tbl[] = 
 	MAKE_EXTENSION_PCI(ttbs1401, 0x13c2, 0x1018),
 	MAKE_EXTENSION_PCI(fsacs1,0x1131, 0x4f60),
 	MAKE_EXTENSION_PCI(fsacs0,0x1131, 0x4f61),
+	MAKE_EXTENSION_PCI(fsact1, 0x1131, 0x5f60),
 	MAKE_EXTENSION_PCI(fsact, 0x1131, 0x5f61),
 	{
 		.vendor    = 0,

--Boundary-00=_q9kpIjwJ3nZZNlB
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_q9kpIjwJ3nZZNlB--
