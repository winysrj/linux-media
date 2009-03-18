Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2IN2eet008651
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 19:02:41 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2IN2L1M031825
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 19:02:21 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Main Backup <vvb.backup@rambler.ru>
In-Reply-To: <1195761635.1237394461.164637724.85123@mcgi27.rambler.ru>
References: <1195761635.1237394461.164637724.85123@mcgi27.rambler.ru>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 00:01:27 +0100
Message-Id: <1237417287.3453.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: AverTV problem
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

Hello,

Am Mittwoch, den 18.03.2009, 19:41 +0300 schrieb Main Backup:
> I'm terribly sorry, may be you can't help me, but I don't know whom 
> should I wrote this.
> 
>  Under WindowsXP I can see channel at frequency 215.25 MHz, but under 
> linux I can not.
>  This channel cannot be found at automatic scan and even if I write 
> correct numbers at stationlist.xml file, I can not see nothing but white 
> noise at this frequency.
>  It seems strange a little bit, because under Linux I can easily see 
> channels at 207.00 MHz and 223.25 MHz.

yes, at least I don't remember such a report for now.

Usually it means that the tuner's VHF low/high takeover frequency is
wrong, but since all three are in VHF high this can be excluded.

>  I have AverMedia 7133/7135 tuner AverTV 305/307/505/507 (information 
> was taken from Windows).
> 
>  I have Fedora Core 10, x86_64.
>  There are two lines in /etc/modprobe.conf:
> ----
> options saa7134 secam=d card=102 tuner=38 i2c_scan=1
> options tuner secam=d radio_range=66

Hmm, maybe that 215.25 one is not secam=d, but even with a wrong TV
standard you usually get a little more than noise only.

Maybe you can try, if the driver can auto detect something there without
setting secam=d. Would still cause problems anyway, since we have no
safe method to auto detect the different SECAM standards.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
