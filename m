Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RGCWjk019841
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 12:12:32 -0400
Received: from smtp802.mail.ird.yahoo.com (smtp802.mail.ird.yahoo.com
	[217.146.188.62])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2RGCHdv024448
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 12:12:17 -0400
Message-ID: <47EBC75E.8040905@btinternet.com>
Date: Thu, 27 Mar 2008 16:12:14 +0000
From: Edward Ludlow <eludlow@btinternet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Problems building v4l-dvb modules
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

I am trying to follow the guide at 
http://linuxtv.org/v4lwiki/index.php/How_to_build_from_Mercurial to get 
my PVR-250 card going.

I get as far as "make load" to insert the modules into the kernel, but 
then it hangs at /sbin/insmod ./b2c2-flexcop-pci.ko

Tried there times now with the same result.

Any ideas?

Thanks,
Ed Ludlow

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
