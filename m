Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1JzZBc-0006yL-HG
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 17:28:09 +0200
Message-ID: <4836E28B.5000405@linuxtv.org>
Date: Fri, 23 May 2008 17:28:11 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@gmail.com>
References: <4836DBC1.5000608@gmail.com>
In-Reply-To: <4836DBC1.5000608@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
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

Hello Anssi,

Anssi Hannula wrote:
> The attached adds support for using multiproto drivers with the old api.

there seems to be a needlessly duplicated line in your patch:

+	/* set delivery system to the default old-API one */
+	if (fe->ops.set_delsys) {
+		switch(fe->ops.info.type) {
+		case FE_QPSK:
+			fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
+			fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
