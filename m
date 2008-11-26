Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+8242490b5b024fab7714+1921+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1L5BC6-0005KR-Ip
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 04:36:02 +0100
Date: Wed, 26 Nov 2008 01:34:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephan Wienczny <Stephan@wienczny.de>
Message-ID: <20081126013434.11734330@pedra.chehab.org>
In-Reply-To: <200810280102.40359.Stephan@wienczny.de>
References: <200810280102.40359.Stephan@wienczny.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy HT PCI (mk2-153b:1177)
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

On Tue, 28 Oct 2008 01:02:33 +0100
Stephan Wienczny <Stephan@wienczny.de> wrote:

> Hi,
> 
> I'd liked to know the current state of development for the above card. Is 
> somebody working on this? I recently bought such a card and would like to get 
> it working.
> Is there something I could do to help you? Debugging, testing, maybe coding?
> 
> Regards
> Stephan Wienczny

Hi Stephan,

There were an old patch for this board, attached on this message:

	http://www.linuxtv.org/pipermail/linux-dvb/2007-October/021378.html

This is the attachment:

	http://www.linuxtv.org/pipermail/linux-dvb/attachments/20071019/cb545c4c/attachment.txt 


This patch seems to be generated against an old experimental cx88 driver that were
never committed.

It doesn't seem to be hard to port it to the current upstream version, but some
things are needed to be done from someone that has this board and some
development knowledge:

1) In general, cx88 boards require some GPIO configurations to enable audio,
IR, and other stuff. However, the patch didn't bring any setup for GPIO's.
You'll need to get the proper values from the original driver. This is done by
using the regspy.exe program that comes with Dscaler (a free TV software for
an alternative paid OS). There are some pages at linuxtv wiki describing how to
get those values;

2) The DVB part will not work, since the patch lacks the needed changes at
cx88-dvb. In general, you'll need to check what demod chip you have on your
board and play with a few parameters adding they at cx88-dvb. You need also to
specify at cx88-cards what IF frequency is used by the demod. In general, you
just need to clone some existing entries on both files.

3) xc3028 tuners may require some special configurations, depending on the way
it is configured. Basically, you should tune into analog mode (after having the
proper gpio values configured) and see if audio works. If it doesn't work, try
to use mts_firmware = 1 at boards description.

If you want to play with this, I've ported the original patch to the current
development tree, as a start for your work.

Maybe the original author may help you on this task (I'm c/c him). Please sign
the patch after finishing it.

Cheers,
Mauro.

---

From: Oliver Moser <oliver.moser@chello.at>

Subject: Re: [linux-dvb] [RE] Problem with Terratec Cinergy HT PCI ID =153b:1177

diff -r d44d9a0951a2 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Nov 25 14:16:13 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Wed Nov 26 00:46:50 2008 -0200
@@ -1967,6 +1967,26 @@
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_TERRATEC_CINERGY_HT_PCI] = {
+		.name           = "TerraTec Cinergy HT PCI (Conexant chipset)",
+		.tuner_type     = TUNER_XC2028,
+		.radio_type     = TUNER_XC2028,
+		.tuner_addr     = 0x61,
+		.radio_addr     = 0x61,
+#if 0
+		.mpeg           = CX88_MPEG_DVB,
+#endif
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 2,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+		} },
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2376,6 +2396,10 @@
 		.subvendor = 0xb200,
 		.subdevice = 0x4200,
 		.card      = CX88_BOARD_SATTRADE_ST4200,
+	}, {
+		.subvendor = 0x153b,
+		.subdevice = 0x1177,
+		.card      = CX88_BOARD_TERRATEC_CINERGY_HT_PCI,
 	},
 };
 
diff -r d44d9a0951a2 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Tue Nov 25 14:16:13 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Wed Nov 26 00:46:50 2008 -0200
@@ -232,6 +232,7 @@
 #define CX88_BOARD_SATTRADE_ST4200         76
 #define CX88_BOARD_TBS_8910                77
 #define CX88_BOARD_PROF_6200               78
+#define CX88_BOARD_TERRATEC_CINERGY_HT_PCI 79
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,



Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
