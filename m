Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Mon, 27 Oct 2008 20:23:23 +0100
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rUhBJy1ynLBfCQ2"
Message-Id: <200810272023.23513.zzam@gentoo.org>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: [linux-dvb] commit 9344:aa3a67b658e8 (DVB-Core update) breaks
	tuning of cx24123
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

--Boundary-00=_rUhBJy1ynLBfCQ2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Manu, hi Steven!

It seems an update of dvb-core breaks tuning of cx24123.
After updating to latest v4l-dvb the nova-s plus card just did no longer lock 
to any channel. So I bisected it, and found this commit:

changeset:   9344:aa3a67b658e8
parent:      9296:e2a8b9b9c294
user:        Manu Abraham <manu@linuxtv.org>
date:        Tue Oct 14 23:34:07 2008 +0400
summary:     DVB-Core update

http://linuxtv.org/hg/v4l-dvb/rev/aa3a67b658e8

It basically did update the dvb-kernel-thread and enhanced the code using 
get_frontend_algo.

The codepath when get_frontend_algo returns *_ALGO_HW stayed the same, only 
one line got removed: params = &fepriv->parameter

Just re-adding that line made my card working again. Either this was lost, or 
the last two lines using "params" should also be converted to directly 
use "&fepriv->parameters".

Regards
Matthias

--Boundary-00=_rUhBJy1ynLBfCQ2
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="fix-tune-algo-hw.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-tune-algo-hw.diff"

--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ v4l-dvb/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -584,6 +584,7 @@ restart:
 
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
+					params = &fepriv->parameters;
 					fepriv->state = FESTATE_TUNED;
 				}
 

--Boundary-00=_rUhBJy1ynLBfCQ2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_rUhBJy1ynLBfCQ2--
