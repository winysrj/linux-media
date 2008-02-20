Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1K4J6KI011268
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 23:19:06 -0500
Received: from smtp.bri.people.net.au (smtp.bri.people.net.au [218.214.227.5])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1K4IWS8031381
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 23:18:33 -0500
From: "Lyal Collins" <lyalc@swiftdsl.com.au>
To: <video4linux-list@redhat.com>, <linux-dvb@linuxtv.org>
References: <1203434275.6870.25.camel@tux><Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de><1203457264.8019.6.camel@anden.nu>
	<1203459408.28796.19.camel@youkaida><Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
	<1203461440.5358.2.camel@pc08.localdom.local>
Date: Wed, 20 Feb 2008 14:18:27 +1000
Message-ID: <000301c87377$a5389370$0c03a8c0@VectraLyal>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1203461440.5358.2.camel@pc08.localdom.local>
Cc: 
Subject: Supported device?
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

I have an Gigabyte U8000 USB device, but can't find any linux support for
it, wither by googling or following this list for several weeks.

lsusb output:
ID 1044:7002 Chu Yuen Enterprise Co., Ltd 

According to this, this device is based on the Dibcom chipset.
http://murga-linux.com/puppy/viewtopic.php?t=24065
However, nothing seems to identify the device after following all the
instructions.

I've tried the v4l suite, as well as a mythbuntu installation that works
with a Dvico Fusion card.

Any better pointers or tips?

Thanks
lyalc

-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.5.446 / Virus Database: 269.20.7/696 - Release Date: 16/02/2008
12:00 AM
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
