Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB13IMxU025150
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 22:18:22 -0500
Received: from smtp103.rog.mail.re2.yahoo.com (smtp103.rog.mail.re2.yahoo.com
	[206.190.36.81])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB13ICOO027048
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 22:18:12 -0500
Message-ID: <4933576F.5040405@rogers.com>
Date: Sun, 30 Nov 2008 22:18:07 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
References: <493340A6.5050308@rogers.com>
	<200811302047.41466.vanessaezekowitz@gmail.com>
In-Reply-To: <200811302047.41466.vanessaezekowitz@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld ATSC 110 and NTSC [was: 2.6.25+ and KWorld ATSC
	110	inputs]
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

Vanessa Ezekowitz wrote:
> On my setup, with an ATSC 120 (not the 110), power cycling or rebooting is still necessary to switch between analog/NTSC and digital/ATSC modes.  Trying to load both DVB and V4L drivers either renders the card inoperable, or one or the other mode simply won't work.
>
> In my case, for example, loading the analog driver (modprobe cx8800) followed by the DVB drivers (modprobe cx88-dvb) results in working analog mode, but digital mode is defunct.  Rebooting and loading either of the two alone results in that mode working fine indefinitely.
>
> Has there been a change to the driver that I'm not aware of?  I'm curious...

Ah, ok.  Thanks for the report Vanessa.   I must have been thinking of
something else -- sorry for providing that moment of false hope :P

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
