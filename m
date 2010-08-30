Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <4ernov@gmail.com>) id 1Oq2AB-0001cX-6N
	for linux-dvb@linuxtv.org; Mon, 30 Aug 2010 13:04:31 +0200
Received: from mail-qw0-f54.google.com ([209.85.216.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Oq2AA-0002zS-5E; Mon, 30 Aug 2010 13:04:30 +0200
Received: by qwg5 with SMTP id 5so6073847qwg.41
	for <linux-dvb@linuxtv.org>; Mon, 30 Aug 2010 04:04:29 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 15:04:28 +0400
Message-ID: <AANLkTint6gwvi8t-XAKbrT==F6-1=LZn-BOJ-peLh2HY@mail.gmail.com>
From: 4ernov <4ernov@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Current status of cx23885-alsa
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
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hello,
I'm working at adding support of GotView PCIe tuner to cx23885 driver,
I'm quite successful in it for now but I found that audio part of this
driver (cx23885-alsa) is currently not in the main kernel tree and is
maintained in a separate tree. Does anybody now, what its actual
status is and why it is still not in the main tree? Maybe it has some
serious problems? Perhaps I could help its development somehow.

Thanks in advance,
Alexey Chernov

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
