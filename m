Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5MGZl4d021478
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 12:35:47 -0400
Received: from smtp1.sscnet.ucla.edu (smtp1.sscnet.ucla.edu [128.97.229.231])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n5MGZVwE026600
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 12:35:31 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id n5MGZVJb032082
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 09:35:31 -0700
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id P9gtEoyfHirL for <video4linux-list@redhat.com>;
	Mon, 22 Jun 2009 09:35:23 -0700 (PDT)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id n5MGZJb8032076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 09:35:19 -0700
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id n5MGZCSB018596
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 09:35:12 -0700
Received: from TimTi-2.local (vpn-8061f42c.host.ucla.edu [128.97.244.44])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id n5MGZ67B004551
	for <video4linux-list@redhat.com>; Mon, 22 Jun 2009 09:35:07 -0700 (PDT)
Message-ID: <4A3FB2E8.50606@cogweb.net>
Date: Mon, 22 Jun 2009 09:35:52 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Error logging
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

v4l device errors, such as VBI read errors, are no longer showing up 
anywhere in my logs -- not in dmesg, not in syslog, not in 
/var/log/debug. I'm running Debian sid.

I see them in the terminal window where I run the recording process. 
They used to show up in dmesg and syslog.

Does anybody know what I can do to direct these errors to syslog? Is 
this change due to my local configuration or upstream changes in logging?

Here's my syslog.conf:

#  /etc/syslog.conf     Configuration file for syslogd.
#
#                       For more information see syslog.conf(5)
#                       manpage.

#
# First some standard logfiles.  Log by facility.
#

auth,authpriv.*                 /var/log/auth.log
*.*;auth,authpriv.none          -/var/log/syslog
cron.*                          /var/log/cron.log
daemon.*                        -/var/log/daemon.log
kern.*                          -/var/log/kern.log
lpr.*                           -/var/log/lpr.log
mail.*                          -/var/log/mail.log
user.*                          -/var/log/user.log
uucp.*                          /var/log/uucp.log

Appreciate any insights into this.

Cheers,
David


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
