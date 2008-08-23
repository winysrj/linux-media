Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KWun6-0006sl-Ey
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 17:12:37 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Aug 2008 17:11:35 +0200
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
In-Reply-To: <48B01765.8020104@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oiCsIhs3MZrYMNW"
Message-Id: <200808231711.36277@orion.escape-edv.de>
Cc: Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
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

--Boundary-00=_oiCsIhs3MZrYMNW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

e9hack wrote:
> Eberhard Kaltenhaeuser schrieb:
> > Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card 
> > anymore:
> > 
> 
> I think it is a problem of this changeset http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d 
> from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions. 
> The i2c-read code was changed from:
> 
> 	if ((ret = i2c_transfer (state->i2c, &msg1, 1)) != 1)
> 		return ret;
> 
> 	if ((ret = i2c_transfer (state->i2c, &msg2, 1)) != 1)
> 		return ret;
> 
> to:
> 	if (state->config->repeated_start_workaround) {
> 		ret = i2c_transfer(state->i2c, msg, 3);
> 		if (ret != 3)
> 			return ret;
> 	} else {
> 		ret = i2c_transfer(state->i2c, &msg[1], 2);
> 		if (ret != 2)
> 			return ret;
> 	}

I think you are right.

Btw, I don't understand Patrick's workaround.

As the tuner does not support repeated start conditions, the solution
is to send two separate messages, as it was before.

Does the attached patch fix the problem?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_oiCsIhs3MZrYMNW
Content-Type: text/x-diff;
  charset="us-ascii";
  name="s5h1420_repeated_start.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="s5h1420_repeated_start.diff"

diff -r 1760a612cc98 linux/drivers/media/dvb/frontends/s5h1420.c
--- a/linux/drivers/media/dvb/frontends/s5h1420.c	Sun Aug 03 05:02:35 2008 +0200
+++ b/linux/drivers/media/dvb/frontends/s5h1420.c	Sat Aug 23 17:07:01 2008 +0200
@@ -94,8 +94,11 @@ static u8 s5h1420_readreg(struct s5h1420
 		if (ret != 3)
 			return ret;
 	} else {
-		ret = i2c_transfer(state->i2c, &msg[1], 2);
-		if (ret != 2)
+		ret = i2c_transfer(state->i2c, &msg[1], 1);
+		if (ret != 1)
+			return ret;
+		ret = i2c_transfer(state->i2c, &msg[2], 1);
+		if (ret != 1)
 			return ret;
 	}
 

--Boundary-00=_oiCsIhs3MZrYMNW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_oiCsIhs3MZrYMNW--
