Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NDHicJ025616
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 09:17:44 -0400
Received: from n3.bullet.mail.gq1.yahoo.com (n3.bullet.mail.gq1.yahoo.com
	[67.195.9.86])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9NDGjln007197
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 09:16:46 -0400
Date: Thu, 23 Oct 2008 06:16:45 -0700 (PDT)
From: foobob <fookokolala@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <157600.42468.qm@web110011.mail.gq1.yahoo.com>
Subject: Gigabyte U8000-RH analog support
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

Hi to everyone,

The digital part of Gigabyte U8000-RH (http://giga-byte.co.uk/Products/TVCard/Products_Spec.aspx?ClassValue=TV+Card&ProductID=2441&ProductName=GT-U8000-RH) works fine when following these instructions (http://linuxtv.org/wiki/index.php/Gigabyte_U8000-RH). Briefly, this is done by compiling the v4l-dvb driver and loading the dvb-usb-dib0700-1.20 and xc3028-v27 modules.

I read that "currently only DVB-T digital TV/HDTV is working because there is no driver written for the CX25843-24Z audio/video decoder which is probably used for the analogue TV/FM radio portion of the device."

Will there be a driver for the analog part (CX25843-24Z chip) in the near future? 
(Or maybe there is a way to make it work, which i don't know...)

thanks in advance,
bob

----
dmseg: http://pastebin.com/m58a3bae6

bob@laptop:~$ uname -r
2.6.24-21-generic

bob@laptop:~$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=8.04
DISTRIB_CODENAME=hardy
DISTRIB_DESCRIPTION="Ubuntu 8.04.1"


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
