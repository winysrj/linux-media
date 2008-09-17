Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jcoles0727@rogers.com>) id 1KfmVT-0001bP-F2
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 04:11:06 +0200
Message-ID: <48D06713.2050302@rogers.com>
Date: Tue, 16 Sep 2008 22:10:27 -0400
From: Jonathan Coles <jcoles0727@rogers.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] More impossible instructions
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

Thinking I might need firmware for xc3028, I went to your Xceive 
XC3028/XC2028 Wiki page. The instructions under "How to Obtain the 
Firmware" contain this gem:

#       3) run the script:
#               linux/Documentation/video4linux/extract_xc3028.pl

So where is this? /linux? ~/linux?
I eventually realized is 
http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/extract_xc3028.pl. 
But if I try to download it, I get an XML file instead.

Is there a way to get this script other than copying and pasting it line 
by line from the browser?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
