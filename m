Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 1 Aug 2008 11:26:13 +1000
From: Anton Blanchard <anton@samba.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080801012613.GE7094@kryten>
References: <20080801012319.GB7094@kryten> <20080801012513.GC7094@kryten>
	<20080801012554.GD7094@kryten>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080801012554.GD7094@kryten>
Cc: linuxdvb@itee.uq.edu.au, stev391@email.com
Subject: [linux-dvb] [PATCH 4/4] Support IR remote on FusionHDTV DVB-T Dual
	Express
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


From: Chris Pascoe <c.pascoe@itee.uq.edu.au>

Support IR remote on FusionHDTV DVB-T Dual Express

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:06:07.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:09:06.000000000 +1000
@@ -521,6 +521,9 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 		/* FIXME: Implement me */
 		break;
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+		request_module("ir-kbd-i2c");
+		break;
 	}
 
 	return 0;

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
