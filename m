Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6BSfhn001439
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 06:28:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6BSRKY032305
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 06:28:27 -0500
Date: Sat, 6 Dec 2008 09:28:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20081206092812.7753125d@pedra.chehab.org>
In-Reply-To: <4936F718.2000101@oracle.com>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<4936F718.2000101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org,
	linux-next@vger.kernel.org, video4linux-list@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 3 (media/video/cx88)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Randy,

On Wed, 03 Dec 2008 13:16:08 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20081202:
> > 
> > Today's tree fails the powerpc allyesconfig build.
> 
> 
> drivers/built-in.o: In function `cx88_call_i2c_clients':
> (.text+0xbafc7): undefined reference to `videobuf_dvb_get_frontend'
> drivers/built-in.o: In function `cx8802_probe':
> cx88-mpeg.c:(.devinit.text+0x61b3): undefined reference to `videobuf_dvb_alloc_frontend'
> cx88-mpeg.c:(.devinit.text+0x61d9): undefined reference to `videobuf_dvb_dealloc_frontends'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> 
> config attached.

It required some tricks to fix this one ;) Patch is attached. On my tests, all combinations worked
properly.

Cheers,
Mauro

--

cx88: fix compilation when cx8800=y and cx88-dvb=m

The current Kconfig rules allow having the core cx88 driver (cx8800) compiled in-kernel,
and cx88 sub-drivers (cx88-alsa, cx88-blackbird, cx88-dvb) to be compiled as modules.

However, if you select cx88-dvb as a module, it will select videobuf_dvb as a module also.

As pointed by Randy Dunlap <randy.dunlap@oracle.com>, using those .config entries:

CONFIG_VIDEO_CX88=y
# CONFIG_VIDEO_CX88_BLACKBIRD is not set
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=m

Will produce those errors:

drivers/built-in.o: In function `cx88_call_i2c_clients':
(.text+0xbafc7): undefined reference to `videobuf_dvb_get_frontend'
drivers/built-in.o: In function `cx8802_probe':
cx88-mpeg.c:(.devinit.text+0x61b3): undefined reference to `videobuf_dvb_alloc_frontend'
cx88-mpeg.c:(.devinit.text+0x61d9): undefined reference to `videobuf_dvb_dealloc_frontends'
make[1]: *** [.tmp_vmlinux1] Error 1

A simple fix would be just to make cx88-mpeg to be depend on VIDEO_CX88_DVB || VIDEO_CX88_BLACKBIRD.
However, cx88-i2c has a conditional test to call videobuf_dvb_get_frontend() if VIDEO_CX88_DVB.

As cx88-i2c is part of cx88 (compiled with Y) and videobuf_dvb_get_frontend is
part of videobuf_dvb (compiled with M), this will cause another error.

So, it is needed also to deny having cx88=y and cx88_dvb=m.

This patch also fixes a minor issue where cx8802 helper module were inconditionally compiled,
even on setups where it would never be used.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 0b9e5fa..96242ad 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_CX88
-	tristate "Conexant 2388x (bt878 successor) support"
+	tristate "Conexant 2388x (bt878 successor) support (cx88)"
 	depends on VIDEO_DEV && PCI && I2C && INPUT
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
@@ -43,9 +43,21 @@ config VIDEO_CX88_BLACKBIRD
 	  To compile this driver as a module, choose M here: the
 	  module will be called cx88-blackbird.
 
-config VIDEO_CX88_DVB
-	tristate "DVB/ATSC Support for cx2388x based TV cards"
+config VIDEO_CX88_ALLOW_DVB
+	boolean "DVB/ATSC Support for cx2388x based TV cards"
 	depends on VIDEO_CX88 && DVB_CORE
+
+	---help---
+	  This adds support for DVB/ATSC cards based on the
+	  Conexant 2388x chip.
+
+	  if cx88 driver is compiled as a module, the
+	  dvb support module will be called cx88-dvb.
+
+config VIDEO_CX88_DVB
+	tristate
+	default y
+	depends on VIDEO_CX88 && DVB_CORE && VIDEO_CX88_ALLOW_DVB
 	select VIDEOBUF_DVB
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
@@ -62,12 +74,11 @@ config VIDEO_CX88_DVB
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	---help---
-	  This adds support for DVB/ATSC cards based on the
-	  Conexant 2388x chip.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called cx88-dvb.
+config VIDEO_CX88_MPEG
+	tristate
+	default y
+	depends on VIDEO_CX88_DVB || VIDEO_CX88_BLACKBIRD
 
 config VIDEO_CX88_VP3054
 	tristate "VP-3054 Secondary I2C Bus Support"
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 6ec30f2..b06b127 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -3,7 +3,8 @@ cx88xx-objs	:= cx88-cards.o cx88-core.o cx88-i2c.o cx88-tvaudio.o \
 cx8800-objs	:= cx88-video.o cx88-vbi.o
 cx8802-objs	:= cx88-mpeg.o
 
-obj-$(CONFIG_VIDEO_CX88) += cx88xx.o cx8800.o cx8802.o
+obj-$(CONFIG_VIDEO_CX88) += cx88xx.o cx8800.o
+obj-$(CONFIG_VIDEO_CX88_MPEG) += cx8802.o
 obj-$(CONFIG_VIDEO_CX88_ALSA) += cx88-alsa.o
 obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
