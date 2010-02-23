Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ocagdas@yahoo.com>) id 1NjuZD-0008FC-5p
	for linux-dvb@linuxtv.org; Tue, 23 Feb 2010 14:12:47 +0100
Received: from web57006.mail.re3.yahoo.com ([66.196.97.110])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with smtp
	for <linux-dvb@linuxtv.org>
	id 1NjuZC-0001Eq-8y; Tue, 23 Feb 2010 14:12:46 +0100
Message-ID: <829000.26472.qm@web57006.mail.re3.yahoo.com>
Date: Tue, 23 Feb 2010 05:12:43 -0800 (PST)
From: ozgur cagdas <ocagdas@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] soft demux device
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

Hi All,

I have just compiled v4l-dvb successfully. My aim is to develop some experimental dvb applications on top of this dvb kernel api. Initially, I do not want to use any hardware and would like to play with the recorded ts files I have. So, is there any software demux device available within this package or somewhere else? If so, how can I load this device and make it work on a given ts file circularly? On the other hand, I have no /dev/dvb node  at the moment, so should I do anything for this or would loading the driver create it automatically?

Thanks in advance.

Cheers,

Ozgur.


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
