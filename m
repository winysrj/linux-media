Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JTO7Z-0006fR-3Q
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 22:10:53 +0100
Received: by wx-out-0506.google.com with SMTP id s11so1279315wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 13:10:47 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Sun, 24 Feb 2008 22:10:58 +0100
Message-Id: <1203887458.6735.17.camel@tux>
Mime-Version: 1.0
Subject: [linux-dvb] conflicts between v4l-dvb and out of tree modules
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

Hi since I've installed v4l-dvb drivers from the hg tree to make my
nova-t stick work, my webcam based on uvcvideo drivers stopped working
complaining about unknown symbol errors.
I ran make kernel-links and tried to recompile uvcvideo module. Even
with a freshly compiled module the unknown symbol error still stood.
You can find a summary of the problem in the linux-uvc mailing list with
the solution I've found:
https://lists.berlios.de/pipermail/linux-uvc-devel/2008-February/003088.html
https://lists.berlios.de/pipermail/linux-uvc-devel/2008-February/003104.html

I don't know too much about kernel development but it seems that
Module.symvers file contains a checksum of all the exported symbols.
This file is updated in the hg mercurial tree but not in the linux build
dir so external modules are compiled with outdated symbol versions.
Is there a way to update symbols in in /lib/modules/`uname
-r`/build/Module.symvers? maybe something like this should be done in
the makelinks.sh scripts?
Please note that, looking for a solution, I've many unaswered questions
from v4l-dvb and em28xx users complaining that their webcam stopped
working. So it's not an uncommon issue.

Regards,
Filippo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
