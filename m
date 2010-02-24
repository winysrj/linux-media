Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ocagdas@yahoo.com>) id 1NkFra-0005eo-8G
	for linux-dvb@linuxtv.org; Wed, 24 Feb 2010 12:57:11 +0100
Received: from web57007.mail.re3.yahoo.com ([66.196.97.111])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with smtp
	for <linux-dvb@linuxtv.org>
	id 1NkFrZ-0004xw-B4; Wed, 24 Feb 2010 12:57:09 +0100
Message-ID: <753100.2204.qm@web57007.mail.re3.yahoo.com>
Date: Wed, 24 Feb 2010 03:57:07 -0800 (PST)
From: ozgur cagdas <ocagdas@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] soft demux device
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

Thanks very much for the previous information. To give it a go just as it is, I've loaded dvb_dummy_fe module manually and many other modules including dvb_core as well, but no hope, don't have /dev/dvb folder yet. As I've mentioned earlier, I do not have a hardware at the moment, so I should trigger loading of proper modules manually. In my scenario, which modules should I load? Any simple set of modules that'd create necessary /dev/dvb/ and subsequent would do for me. If it matters, I am using 2.6.31 kernel and ubuntu 9.10 distribution.

Cheers,

Ozgur.


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
