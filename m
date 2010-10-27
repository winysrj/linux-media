Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <4ernov@gmail.com>) id 1PBAGG-0001SP-4G
	for linux-dvb@linuxtv.org; Wed, 27 Oct 2010 19:58:08 +0200
Received: from mail-ew0-f54.google.com ([209.85.215.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PBAGF-0007Hh-8m; Wed, 27 Oct 2010 19:58:07 +0200
Received: by ewy28 with SMTP id 28so586739ewy.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Oct 2010 10:58:06 -0700 (PDT)
From: Alexey Chernov <4ernov@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 27 Oct 2010 21:58:01 +0400
MIME-Version: 1.0
Message-Id: <201010272158.02050.4ernov@gmail.com>
Subject: [linux-dvb] Patch for cx23885 with GoTView PCI-E X5 3D tuner support
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hello,

I've added support of GoTView PCI-E X5 3D tuner to cx23885 driver (thanks to 
Gotview support which helped a lot with settings). Could you please help me 
with information, against what version I should make a patch to it be 
considered by Linux TV team? Will it be finally possible to add support of the 
tuner to main kernel tree?

Thanks in advance,
Alexey

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
