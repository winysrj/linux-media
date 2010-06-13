Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <C.Hemsing@gmx.net>) id 1ONhAU-0004q0-BL
	for linux-dvb@linuxtv.org; Sun, 13 Jun 2010 08:59:43 +0200
Received: from mail.gmx.net ([213.165.64.20])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with smtp
	for <linux-dvb@linuxtv.org>
	id 1ONhAT-0003wp-2e; Sun, 13 Jun 2010 08:59:42 +0200
Received: from [192.168.129.248] (dino.hcc-intra.de [192.168.129.248])
	by dino.hcc-intra.de (Postfix) with ESMTPS id 7C4DF690AE9
	for <linux-dvb@linuxtv.org>; Sun, 13 Jun 2010 08:59:39 +0200 (CEST)
Message-ID: <4C1481DB.6030404@gmx.net>
Date: Sun, 13 Jun 2010 08:59:39 +0200
From: "C. Hemsing" <C.Hemsing@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] af9015, af9013 DVB-T problems
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

To the maintainer of the af9015, af9013 modules:

A recent kernel (but the problem had been the same with older kernels):
2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3 22:02:19 UTC 2010 i686 GNU/Linux

Latest (as of yesterday) checkout of v4l-dvb (but the problem had been
the same with older checkouts).

Dual channel USB DVB-T stick initialized ok, but
regularly the stick does not tune properly on one of the two channels
and the kernel shows these error messages at the same time:

[14410.717905] af9015: command failed:2
[14410.717913] af9013: I2C read failed reg:d330
[18208.030546] af9015: command failed:2
[18208.030554] af9013: I2C read failed reg:d2e6

I'm willing to help debug. Who is the maintainer of af9015, af9013?

Cheers,
Chris


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
