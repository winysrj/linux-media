Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB11f6UX028553
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 20:41:06 -0500
Received: from smtp123.rog.mail.re2.yahoo.com (smtp123.rog.mail.re2.yahoo.com
	[206.190.53.28])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB11ethQ020388
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 20:40:55 -0500
Message-ID: <493340A6.5050308@rogers.com>
Date: Sun, 30 Nov 2008 20:40:54 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: KWorld ATSC 110 and NTSC [was: 2.6.25+ and KWorld ATSC 110 inputs]
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

stuart wrote:
> V4L support for the KWorld ATSC120 is limited.  There a numerous threads 
> here which talk about the problems and some work arounds.  The 
> developers have talked about adding support but consider new features at 
> the cost of an overhaul of the current driver.
>
> Right now I believe you can not use both ATSC and NTSC tuners w/o power 
> cycling your computer and bringing it up with (only) the appropriate 
> driver.  Also, I don't believe the IR receiver works under V4L.  This 
> card replaced the Kworld 110 and Kworld 115 tuners.  If you can find 
> these older Kworld ATSC tuners, I would buy them instead as I believe 
> they are better supported under V4L (I also have a Kworld ATSC110 - but 
> only use it for ATSC tuning as well).
>
> Go here and read up on how people are setting this card up:
> > http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120
>
> I'm using the Kworld 120 as an ATSC tuner and nothing else in a Debian 
> mythtv slave back end system.

Stuart, while I don't know for sure, I believe that information about
the power cycling is now obsolete and the driver for the ATSC 120 is
working.

In any regard, such things are not related to the difficulties Bill is
experiencing with his 110 card.  I'll detail in the next message.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
