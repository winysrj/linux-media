Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72EnVOM030664
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 10:49:31 -0400
Received: from n35.bullet.mail.ukl.yahoo.com (n35.bullet.mail.ukl.yahoo.com
	[87.248.110.168])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72EnGV6023565
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 10:49:17 -0400
From: Lars Oliver Hansen <lolh@ymail.com>
To: video4linux-list@redhat.com
In-Reply-To: <1217674881.7839.2.camel@lars-laptop>
References: <1217674881.7839.2.camel@lars-laptop>
Date: Sat, 02 Aug 2008 16:49:09 +0200
Message-Id: <1217688549.6605.5.camel@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: no video device with saa7134 driver
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

Am Samstag, den 02.08.2008, 13:01 +0200 schrieb Lars Oliver Hansen:

> Hello,
> 
> I have problems getting a video device under Ubuntu 8.04. I compiled and
> installed the experimental saa7134 driver according to
> http://mcentral.de/wiki/index.php5/AverMedia_Cardbus_Hybrid_TV_FM_E506R
> and it shows up like this:
> 
> ﻿Module                  Size  Used by

....

> 
> 
> Yet there is no video device video0 listed under dev/. Any advice? I'm
> using that AVer E506R Hybrid Cardbus card.


Hello again,

this problem is solved: if I plugin the card, do a modprobe saa7134,
reboot, the card gets turned on and there is a dev/video0. This order is
different than the last few steps in the link provided above. The reason
I never got the card to work was probably that plugging in after the
reboot doesn't turn it on and on another reboot the driver isn't loaded
anymore. I now load it by etc/modules and the card works. Thanks for
your work!

Lars
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
