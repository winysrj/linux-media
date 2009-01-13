Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1LMqIF-0004tc-4A
	for linux-dvb@linuxtv.org; Tue, 13 Jan 2009 21:55:24 +0100
Received: by fg-out-1718.google.com with SMTP id e21so130054fga.25
	for <linux-dvb@linuxtv.org>; Tue, 13 Jan 2009 12:55:19 -0800 (PST)
Message-ID: <496CFFB3.40109@googlemail.com>
Date: Tue, 13 Jan 2009 21:55:15 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <496BA8BE.4080309@googlemail.com>
	<9ac6f40e0901121341h4e447bbxbf26c7ff7153dcc0@mail.gmail.com>
In-Reply-To: <9ac6f40e0901121341h4e447bbxbf26c7ff7153dcc0@mail.gmail.com>
Subject: Re: [linux-dvb] compile problems on 2.6.29-rc1
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

e9hack@googlemail.com schrieb:
> 2009/1/12 e9hack <e9hack@googlemail.com>
>> I've problems to compile the current hg tree with some modifications on
>> linux 2.6.29-rc1.
> 
> 
> It seems, any included file like #include <media/....> uses the file from
> kernel source tree instead of the v4l-dvb tree.

Hi,

I could solve my compile problem with a little patch:

diff -r b09b5128742f v4l/Makefile
--- a/v4l/Makefile      Mon Jan 12 22:50:52 2009 -0200
+++ b/v4l/Makefile      Tue Jan 13 21:45:36 2009 +0100
@@ -161,6 +161,7 @@ ifeq ($(VERSION).$(PATCHLEVEL),2.6)

  # Needed for kernel 2.6.24 or upper
  KBUILD_CPPFLAGS := -I$(SUBDIRS)/../linux/include $(KBUILD_CPPFLAGS) -I$(SUBDIRS)/
+ LINUXINCLUDE := -I$(SUBDIRS)/../linux/include $(LINUXINCLUDE) -I$(SUBDIRS)/

In 2.6.28.1 LINUXINCLUDE is part of KBUILD_CPPFLAGS of the kernel. In 2.6.29-rc1
LINUXINCLUDE is part of the command line for gcc. LINUXINCLUDE is include before
KBUILD_CPPFLAGS.

Regards,
Hartmut

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
