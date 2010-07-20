Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <restlessbrain@gmail.com>) id 1Ob8xR-0001vh-HP
	for linux-dvb@linuxtv.org; Tue, 20 Jul 2010 11:17:50 +0200
Received: from mail-bw0-f54.google.com ([209.85.214.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Ob8xQ-0004ES-CU; Tue, 20 Jul 2010 11:17:49 +0200
Received: by bwz12 with SMTP id 12so3355196bwz.41
	for <linux-dvb@linuxtv.org>; Tue, 20 Jul 2010 02:17:47 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Jul 2010 11:17:47 +0200
Message-ID: <AANLkTim3sbg90SKwNEP3COINRD5Z26Hj60_exb7_DEXd@mail.gmail.com>
From: code unknown <restlessbrain@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] CAM Support for Terratec Cinergy S2 HD or Technisat
	SkyStar HD2
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

Hi,

I am using a Terratec Cinergy S2 HD with Mantis driver and so far the
card runs without problems.

The only thing is that CAM seems not to be supported - it is defined
out from the source code:

#if 0
   err = mantis_ca_init(mantis);
   if (err < 0) {
            dprintk(MANTIS_ERROR, 1, "ERROR: Mantis CA initialization
failed <%d>", err);
   }
#endif


My questions are:

1. Is anybody currently working on CAM support? Will it be supported soon?

2. Is there another DVB-S2 HD card which has CAM supported?


Thanks,

rinf

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
