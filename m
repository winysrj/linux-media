Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Sat, 6 Sep 2008 14:57:59 +0300
References: <48BF6A09.3020205@linuxtv.org>
In-Reply-To: <48BF6A09.3020205@linuxtv.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HBnwI/xQbwlz88K"
Message-Id: <200809061457.59955.liplianin@tut.by>
Subject: Re: [linux-dvb] S2API - First release
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

--Boundary-00=_HBnwI/xQbwlz88K
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 4 September 2008 07:54:33 Steven Tot=
h =CE=C1=D0=C9=D3=C1=CC(=C1):
> Hello,
>
> It's been a crazy few days, please forgive my short absence.
>
> What have I been doing? Well, rather than spending time discussing a new
> S2API on the mailing list, I wanted to actually produce a working series
> of patches that kernel and application developers could begin to test.
>
> Here's where all of the new S2API patches will now appear:
>
> http://linuxtv.org/hg/~stoth/s2
>
> In addition, here's is a userland application that demonstrates tuning
> the current DVB-S/T/C and US ATSC modulations types using the new API.
> (www.steventoth.net/linux/s2/tune-v0.0.1.tgz)
>
> A tuning demo app? What? Obviously, tuning older modulation types via
> the new API isn't a requirements, but it's a useful validation exercise
> for the new S2API. What _IS_ important is..... that it also demonstrates
> using the same tuning mechanism to tune DVB-S2 8PSK / NBC-QPSK
> modulation types, and also has rudimentary ISDB-T support for any
> developers specifically interested.
>
> This S2API tree also contains support for the cx24116 demodulator
> driver, and the Hauppauge HVR4000 family of S2 products. So those
> interested testers/developers can modify the tune.c app demo and make
> changes specific to their area, and try experimenting with the new API
> if they desire. [1]
>
> Obviously, tune.c isn't intelligent, it's not a replacement for szap,
> tzap or whatever - it's simply a standalone S2API test tool, that
> demonstrates the important API interface.
>
> QAM/ATSC are working well, the HVR4000 changes look fine according to
> the debug log (although I have no local satellite feed for testing
> tonight). DVB-T should just work as-is, but I can't test this for a day
> or so. I.E. I've tested what I can in the US but we might have a few
> bugs or gotchas!
>
> If anyone is willing to pull the tree and begin testing with the tune.c
> app then please post all feedback on this thread. [2]
>
> I've received a lot of good feedback of the original 2007 patches. I
> expect to start merging those changes of the coming days. Don't be too
> concerned that your changes are not yet merged, keep watching the S2API
> tree and they will soon appear ... along with a lot of general code
> cleanup (checkpatch violations)
>
> I expect to catchup on my older email tomorrow.
>
> Regards to all,
>
> - Steve
> [1] I'll need to review and diff any of the newer HVR4000 driver
> derivatives that people have been using, before merging those changes
> into the S2API tree.
> [2] Remember you're going to need the cx24116 firmware if you're
> specifically testing the HVR4000.... but you probably already know that! =
:)
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Is it possible to add TeVii S460 support to your repository?
Patch included.
I have locked signal with tune.c succesfully.
=20
Igor M. Liplianin

--Boundary-00=_HBnwI/xQbwlz88K
Content-Type: text/plain;
  name="s460.diff"
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1220559854 -10800
# Node ID f898da8b5a04287ed5c0ac282dfe9e3b7efb3507
# Parent 3a4c28521d430bfee3eef546b499fc58dd032952
Added support for TeVii S460 DVB-S/S2 card

From: Igor M. Liplianin <liplianin@me.by>

Added support for TeVii S460 DVB-S/S2 card. The card
based on cx24116 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

--- a/linux/drivers/media/video/cx88/cx88-cards.c	Thu Sep 04 00:17:33 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Sep 04 23:24:14 2008 +0300
@@ -1746,6 +1746,18 @@
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_TEVII_S460] = {
+		.name           = "TeVii S460 DVB-S/S2",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = {{
+			.type   = CX88_VMUX_DVB,
+			.vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2115,6 +2127,10 @@
 		.subvendor = 0x0070,
 		.subdevice = 0x6906,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR4000LITE,
+	}, {
+		.subvendor = 0xD460,
+		.subdevice = 0x9022,
+		.card      = CX88_BOARD_TEVII_S460,
 	},
 };
 
@@ -2686,7 +2702,14 @@
 		tea5767_cfg.priv  = &ctl;
 
 		cx88_call_i2c_clients(core, TUNER_SET_CONFIG, &tea5767_cfg);
+		break;
 	}
+	case  CX88_BOARD_TEVII_S460:
+		cx_write(MO_SRST_IO, 0);
+		msleep(100);
+		cx_write(MO_SRST_IO, 1);
+		msleep(100);
+		break;
 	} /*end switch() */
 
 
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Sep 04 00:17:33 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Sep 04 23:24:14 2008 +0300
@@ -377,6 +377,31 @@
 	return 0;
 }
 
+static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
+				      fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	switch (voltage) {
+		case SEC_VOLTAGE_13:
+			printk("LNB Voltage SEC_VOLTAGE_13\n");
+			cx_write(MO_GP0_IO, 0x00006040);
+			break;
+		case SEC_VOLTAGE_18:
+			printk("LNB Voltage SEC_VOLTAGE_18\n");
+			cx_write(MO_GP0_IO, 0x00006060);
+			break;
+		case SEC_VOLTAGE_OFF:
+		   	printk("LNB Voltage SEC_VOLTAGE_off\n");
+			break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
+
 static int cx88_pci_nano_callback(void *ptr, int command, int arg)
 {
 	struct cx88_core *core = ptr;
@@ -553,6 +578,12 @@
 	.demod_address          = 0x05,
 	.set_ts_params          = cx24116_set_ts_param,
 	.reset_device           = cx24116_reset_device,
+};
+
+static struct cx24116_config tevii_s460_config = {
+	.demod_address = 0x55,
+	.set_ts_params = cx24116_set_ts_param,
+	.reset_device  = cx24116_reset_device,
 };
 
 static int dvb_register(struct cx8802_dev *dev)
@@ -933,6 +964,15 @@
 				0x08, 0x00, 0x00);
 		}
 		break;
+	case CX88_BOARD_TEVII_S460:
+	        dev->dvb.frontend = dvb_attach(cx24116_attach,
+					       &tevii_s460_config,
+					       &core->i2c_adap);
+		if (dev->dvb.frontend != NULL) {
+			core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
+			dev->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+		}
+		break;
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       core->name);
--- a/linux/drivers/media/video/cx88/cx88.h	Thu Sep 04 00:17:33 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88.h	Thu Sep 04 23:24:14 2008 +0300
@@ -224,6 +224,7 @@
 #define CX88_BOARD_KWORLD_ATSC_120         67
 #define CX88_BOARD_HAUPPAUGE_HVR4000       68
 #define CX88_BOARD_HAUPPAUGE_HVR4000LITE   69
+#define CX88_BOARD_TEVII_S460              70
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--Boundary-00=_HBnwI/xQbwlz88K
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_HBnwI/xQbwlz88K--
