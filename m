Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB12lweb015947
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 21:47:58 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB12liuc015516
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 21:47:44 -0500
Received: by yw-out-2324.google.com with SMTP id 5so839023ywb.81
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 18:47:44 -0800 (PST)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: video4linux-list@redhat.com
Date: Sun, 30 Nov 2008 20:47:41 -0600
References: <493340A6.5050308@rogers.com>
In-Reply-To: <493340A6.5050308@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811302047.41466.vanessaezekowitz@gmail.com>
Subject: Re: KWorld ATSC 110 and NTSC [was: 2.6.25+ and KWorld ATSC 110
	inputs]
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

On Sunday 30 November 2008 07:40:54 pm CityK wrote:
> stuart wrote:
> > V4L support for the KWorld ATSC120 is limited.  There a numerous threads 
> > here which talk about the problems and some work arounds.  The 
> > developers have talked about adding support but consider new features at 
> > the cost of an overhaul of the current driver.
> >
> > Right now I believe you can not use both ATSC and NTSC tuners w/o power 
> > cycling your computer and bringing it up with (only) the appropriate 
> > driver.  Also, I don't believe the IR receiver works under V4L.  This 
> > card replaced the Kworld 110 and Kworld 115 tuners.  If you can find 
> > these older Kworld ATSC tuners, I would buy them instead as I believe 
> > they are better supported under V4L (I also have a Kworld ATSC110 - but 
> > only use it for ATSC tuning as well).
> > Go here and read up on how people are setting this card up:
> > > http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120
> >
> > I'm using the Kworld 120 as an ATSC tuner and nothing else in a Debian 
> > mythtv slave back end system.

The OP was talking about the older 110 to begin with...so he already has one ;)

On my setup, with an ATSC 120 (not the 110), power cycling or rebooting is still necessary to switch between analog/NTSC and digital/ATSC modes.  Trying to load both DVB and V4L drivers either renders the card inoperable, or one or the other mode simply won't work.

In my case, for example, loading the analog driver (modprobe cx8800) followed by the DVB drivers (modprobe cx88-dvb) results in working analog mode, but digital mode is defunct.  Rebooting and loading either of the two alone results in that mode working fine indefinitely.

Has there been a change to the driver that I'm not aware of?  I'm curious...

-- 
"There are some things in life worth obsessing over.  Most
things aren't, and when you learn that, life improves."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
