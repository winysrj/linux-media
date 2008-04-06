Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m36LfUMd006007
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 17:41:30 -0400
Received: from web88210.mail.re2.yahoo.com (web88210.mail.re2.yahoo.com
	[206.190.37.225])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m36LfC4Q004863
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 17:41:12 -0400
Date: Sun, 6 Apr 2008 14:41:05 -0700 (PDT)
From: Dwaine Garden <dwainegarden@rogers.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
MIME-Version: 1.0
Message-ID: <314237.83517.qm@web88210.mail.re2.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Cc: linux-dvb@linuxtv.org
Subject: v4l-dvb tree will not compile all modules??
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I'm trying to compile all the modules in the hg tree.   The tree compiles ok on my mythtv box, but does not compile all of it.
If I compile the 2.6.18 kernel, all the modules do compile properly.   But the v4l-dvb tree still only compiles 198 modules.

make[2]: Leaving directory `/usr/src/linux-source-2.6.18-chw-13'
./scripts/rmmod.pl check
found 198 modules
make[1]: Leaving directory `/myth/v4l-dvb-1abbd650fe07/v4l'

Try it on another box and I get all the modules to compile?????

make[2]: Leaving directory `/usr/src/kernels/2.6.25-0.195.rc8.git1.fc9.i686'
./scripts/rmmod.pl check
found 229 modules
make[1]: Leaving directory `/usr/src/v4l-dvb-37d5a01a14ca/v4l'

What am I missing?

Dwaine




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
