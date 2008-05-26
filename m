Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K0RiW-0005ii-Ha
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 03:41:44 +0200
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1211682783.3200.36.camel@palomino.walls.org>
References: <200805241817.07810.jareguero@telefonica.net>
	<1211682783.3200.36.camel@palomino.walls.org>
Content-Type: multipart/mixed; boundary="=-czDmg4J+6AuywxUp/pZ1"
Date: Sun, 25 May 2008 21:40:48 -0400
Message-Id: <1211766048.20092.7.camel@palomino.walls.org>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] Fix tuner_warn() induced kernel Ooops
	in	simple_tuner_attach()
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


--=-czDmg4J+6AuywxUp/pZ1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2008-05-24 at 22:33 -0400, Andy Walls wrote:
> On Sat, 2008-05-24 at 18:17 +0200, Jose Alberto Reguero wrote:
> > Work well with kernel 2.6.25
> > 
> > Jose Alberto


> It looks like something about the "tuner_warn()" macro is causing
> references to be made to very low memory addresses.  That is probably
> not right.
> 
> So let's look further: here is the same section of
> tuner-simple.c:simple_tuner_attach() after preprocessing, but before
> conversion to assembly:
> 
>     if (fe->ops.i2c_gate_ctrl)
>      fe->ops.i2c_gate_ctrl(fe, 1);
> 
>     if (1 != i2c_transfer(i2c_adap, &msg, 1))
>      do { do { printk("<4>" "%s %d-%04x: " "unable to probe %s,
> proceeding anyway.", priv->i2c_props.name, priv->i2c_props.adap ?
> i2c_adapter_id(priv->i2c_props.adap) : -1, priv->i2c_props.addr,
> tuners[type].name); } while (0); } while (0);
> 
> 
>     if (fe->ops.i2c_gate_ctrl)
>      fe->ops.i2c_gate_ctrl(fe, 0);
>  

> Hmmm. Lots of dereferences of something called "priv".  Looking at the
> top of tuner-simple.c:simple_tuner_attach() we find:
> 
> 1032         struct tuner_simple_priv *priv = NULL;
> 1033         int instance;
> 
> With no other operations on "priv" before the "tuner_warn()"
> invocation.
> 
> So tuner-simple.c:simple_tuner_attach() has a hard coded NULL pointer
> dereference buried in a macro that only sometimes gets executed.


Patch attached.  It compiles.  I assume it works.

I did a search through the rest of tuner-simple.c and did not see any
other instances of tuner_warn() being called without "priv" being
defined.

Regards,
Andy


--=-czDmg4J+6AuywxUp/pZ1
Content-Disposition: attachment; filename=tuner-simple-warn-oops.patch
Content-Type: text/x-patch; name=tuner-simple-warn-oops.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Andy Walls <awalls@radix.net>
# Date 1211765477 14400
# Node ID c49fbcb74feefa8af911236978f42fcc2e18de8e
# Parent  9d04bba82511bd8576a4e3304d507d84ae3522ca
Fix tuner_warn() induced kernel Ooops in simple_tuner_attach()

From: Andy Walls <awalls@radix.net>


The tuner_warn() macro relies on the local variable "priv" to be a valid
pointer.  There was a case in simple_tuner_attach() where this cannot be the
case yet, so tuner_warn() would dereference a NULL "priv" pointer.  Changed
the tuner_warn() to a printk() with the originally intended output format.


Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 9d04bba82511 -r c49fbcb74fee linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Sun May 25 21:31:17 2008 -0400
@@ -1053,8 +1053,10 @@ struct dvb_frontend *simple_tuner_attach
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
 		if (1 != i2c_transfer(i2c_adap, &msg, 1))
-			tuner_warn("unable to probe %s, proceeding anyway.",
-				   tuners[type].name);
+			printk(KERN_WARNING "%s %d-%04x: "
+				"unable to probe %s, proceeding anyway.",
+				"tuner-simple", i2c_adapter_id(i2c_adap),
+				i2c_addr, tuners[type].name);
 
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);

--=-czDmg4J+6AuywxUp/pZ1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-czDmg4J+6AuywxUp/pZ1--
