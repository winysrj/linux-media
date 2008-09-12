Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Fri, 12 Sep 2008 21:02:27 +0300
References: <48C70F88.4050701@linuxtv.org>
In-Reply-To: <48C70F88.4050701@linuxtv.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_z6qyItqbB7+nmXL"
Message-Id: <200809122102.27540.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API Bug fix: ioctl
	FE_SET_PROPERTY/FE_GET_PROPERTY always return error
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

--Boundary-00=_z6qyItqbB7+nmXL
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Steven,

It seems a bug - ioctl FE_SET_PROPERTY/FE_GET_PROPERTY always return error.
Though it can be fixed by many ways, send you patch

Igor

--Boundary-00=_z6qyItqbB7+nmXL
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8875.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8875.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1221241746 -10800
# Node ID 0ca00da5622f88c5df170732267f13e135e3db81
# Parent  9e583c6fa37424e89d254643e7c78b6e714a21ff
Bug fix: ioctl FE_SET_PROPERTY/FE_GET_PROPERTY always return error

From: Igor M. Liplianin <liplianin@me.by>

Bug fix: ioctl FE_SET_PROPERTY/FE_GET_PROPERTY always return error

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 9e583c6fa374 -r 0ca00da5622f linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri Sep 12 00:37:37 2008 -0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri Sep 12 20:49:06 2008 +0300
@@ -1322,7 +1322,7 @@
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	int err = -EOPNOTSUPP;
+	int err = 0;
 
 	struct dtv_properties *tvps = NULL;
 	struct dtv_property *tvp = NULL;

--Boundary-00=_z6qyItqbB7+nmXL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_z6qyItqbB7+nmXL--
