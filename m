Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stealth.banana@gmail.com>) id 1JRqOn-0006I1-14
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 15:58:17 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2175379wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 06:58:10 -0800 (PST)
Message-ID: <344885a10802200658h331e69adj76f560645312546e@mail.gmail.com>
Date: Wed, 20 Feb 2008 14:58:09 +0000
From: "stealth banana" <stealth.banana@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] RTL2831U kernel driver success
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

Just to post that I have total success with the RTL2831U kernel
drivers and watching with Kaffeine.

I took the source from realtek, and added a makefile so it will
compile as a standalone.  This needed a bit of dirtyness in the form
of copying several files that the modules depend upon from the kernel
source to the module directory.  It still throws up a few warnings
when compiling, mostly to do with redefining things (to be expected
really) and unsigned constants, so the realtek code needs some clean
up.

I am using Kubuntu Gutsy.  I have put a .txt file in the Doc directory
showing what is needed so it can be easily changed for other kernels.
The package is availble from here.

http://coronach.adsl24.co.uk/code/rtl2831u_dvb-usb_v0.0.1.tar.bz2

Just unpack, make, sudo make install and it should work on Ubuntu
Gutsy as is.  I have tested it on 2 Kubuntu i386 systems and it works.

I know this is a nasty hack, but it works and the quality and
responsiveness seems a lot better that it does in windows.

I would be interested if anyone else gets this to work.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
