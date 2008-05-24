Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1Jzpdf-0003aO-G4
	for linux-dvb@linuxtv.org; Sat, 24 May 2008 11:02:08 +0200
Received: from [10.11.11.138] (user-514f84eb.l1.c4.dsl.pol.co.uk
	[81.79.132.235])
	by mail.youplala.net (Postfix) with ESMTP id 2D77CD8815E
	for <linux-dvb@linuxtv.org>; Sat, 24 May 2008 11:01:07 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
Date: Sat, 24 May 2008 10:01:06 +0100
Message-Id: <1211619666.26119.34.camel@youkaida>
Mime-Version: 1.0
Subject: [linux-dvb] compiling quickcam messenger driver when v4l-dvb tree
	compiled on	the side
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

Hi all,

I have that laptop, using Ubuntu, with the kernel headers installed.

I have also a recent v4l-dvb tree. The dvb stuff is compiled directly
from that tree using the headers and the DVB stick works very fine.

Now, I have that Logitech quickcam messenger that needs this driver:

http://home.mag.cx/messenger/

It wants to use the kernel headers I have and compile.

But when I want to insert the module, it complains loudly:

[31431.072034] quickcam: Unknown symbol video_devdata
[31431.072436] quickcam: disagrees about version of symbol
video_unregister_device
[31431.072442] quickcam: Unknown symbol video_unregister_device
[31431.072620] quickcam: disagrees about version of symbol
video_register_device
[31431.072624] quickcam: Unknown symbol video_register_device

My guess is that it was compiled against the v4l version in the Ubuntu
header, and that I have in fact a different v4l version in binary form
because I compiled and installed a recent v4l-dvb tree.

Could someone give me directions about how I could compile my webcam
driver against the proper code?

Thanks much,

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
