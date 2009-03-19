Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2JJBSDS008668
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 15:11:28 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2JJBBFC001599
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 15:11:12 -0400
Received: from [192.168.0.201] (adsl-99-144-235-121.dsl.emhril.sbcglobal.net
	[99.144.235.121]) (authenticated bits=0)
	by nlpi053.prodigy.net (8.13.8 smtpauth/dk/map_regex/8.13.8) with ESMTP
	id n2JJB34u017252
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 14:11:10 -0500
Message-ID: <49C298C8.3080100@xnet.com>
Date: Thu, 19 Mar 2009 14:11:04 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Help w/ATSC tuner (kworld 120)
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

Hi...

I know the v4l support of (what I think is the newest) Kworld 120 is not 
100 % (for instance I don't think you can switch between NTSC and ATSC 
w/o a power cycle -or- use the remote control).  However, I had been 
using it for months for ATSC reception w/o any problems.  Then, after a 
Debinan (unstable) update, I lost the card.  I assume I had picked up a 
new release of v4l.  So I tried to re-compile & install my source copy 
of v4l I downloaded last July - but that didn't work. I then downloaded, 
compiled & installed the most recent v4l today - but that didn't work 
either.  Currently, the tuner acts as if the signal is weak.  The 
picture is pixelated and breaks up.  I have swapped the antenna lead 
with a set-top-box ATSC tuner.  The set-top-box appears to work well 
with either it's own antenna lead or the Kworld's antenna lead.

So, now I'm wondering - could something have happened to v4l in the last 
9 months?  For instance, could a v4l code change effect the Kworld 120's 
AGC feature?

FYI: The same antenna provides signals for another Kworld 110 tuner and 
a Happauge NTSC tuner (both in a different computer) as well as a number 
of other appliances.   All of which appear to be working fine.

...thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
