Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 246-113.netfront.net ([202.81.246.113] helo=akbkhome.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailinglist@akbkhome.com>) id 1LiswW-0007W6-AB
	for linux-dvb@linuxtv.org; Sun, 15 Mar 2009 17:12:05 +0100
Received: from wideboy ([192.168.0.27])
	by akbkhome.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Mailfort v1.2) (envelope-from <mailinglist@akbkhome.com>)
	id 1LiswW-0005wX-5r
	for linux-dvb@linuxtv.org; Mon, 16 Mar 2009 00:12:04 +0800
Message-ID: <49BD28C5.8030003@akbkhome.com>
Date: Mon, 16 Mar 2009 00:11:49 +0800
From: Alan Knowles <mailinglist@akbkhome.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] ASUS My Cinema U3100 Mini DMB-TH - Getting them into
	v4l-dvb
Reply-To: linux-media@vger.kernel.org
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

What's the process of getting drivers into v4l-dvb

I've fixed up most of the code that ASUS gave us for the ASUS My Cinema 
U3100 Mini DMB-TH, (it's a Hong Kong / China standard)

At present the code is kludgly overwritten into the dib3000mc.c code, I 
could do with some help/advice on moving it to it's own files, and any 
other tidy ups (like support for signal strength etc.)

The changed/addtional files are available here:

http://www.akbkhome.com/svn/asus_dvb_driver/

Anyway - mail me if you need help building the current set.

Regards
Alan

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
