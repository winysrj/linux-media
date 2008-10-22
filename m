Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as3.mho.net ([64.58.4.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mlnx@mho.com>) id 1KsSbO-0002UU-8z
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 03:33:34 +0200
Received: from smtp.mho.com (localhost [127.0.0.1])
	by as3.mho.net (Spam Firewall) with SMTP id 28CE06CC08C
	for <linux-dvb@linuxtv.org>; Tue, 21 Oct 2008 19:33:26 -0600 (MDT)
Received: from smtp.mho.com (a.smtp.mho.net [64.58.4.6]) by as3.mho.net with
	SMTP id du60gBCBIpaej7zS for <linux-dvb@linuxtv.org>;
	Tue, 21 Oct 2008 19:33:26 -0600 (MDT)
Message-ID: <48FED6CB.7030603@mho.com>
Date: Wed, 22 Oct 2008 01:31:23 -0600
From: Mike Adolf <mlnx@mho.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem making v4l driver tree
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

According to the Mythtv Wiki on the pctv 800i card you need to extract
firmware from windows file and download "v4l-dvb-c800683faf86.tar.gz",
and do a make and make install to get the latest tree of drivers
installed.  However, when I did the make I got the following  error.
------
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
File not found: /lib/modules/2.6.25.16-0.1-pae/build/.config at
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** No rule to make target `.myconfig', needed by
`config-compat.h'.  Stop.
-----
I am use to resolving dependency errors but don't know what to do with
this one. I am using SuSe 11.   Since I do get good video but no sound,
would it be a good idea to do an 'Install-sound' only-once I get it to make?

Mike


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
