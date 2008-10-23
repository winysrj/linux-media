Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9N1wxfY006198
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 21:59:04 -0400
Received: from smtp128.rog.mail.re2.yahoo.com (smtp128.rog.mail.re2.yahoo.com
	[206.190.53.33])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9N1wAEg027599
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 21:58:10 -0400
Message-ID: <48FFDA32.1020206@rogers.com>
Date: Wed, 22 Oct 2008 21:58:10 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com, lee_alkureishi@hotmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: HDTV Wonder - analog portion isn't working
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

Lee Alkureishi wrote:

> I'm hoping someone might be able to help me get the analogue portion of
> my ATI HDTV Wonder up and running. ...When I try to watch tv using the second coaxial input ...I just get a 
> black screen. Scanning for channels produces timeouts at every station 
> (no signal). I'm mainly using mythtv (mythbuntu 8.04, mythtv 0.21, fully 
> updated), but the same thing happens in tvtime and xawtv. I'm unable to 
> find any channels.....I don't know what to do next, to get this analogue input 
> working!
>   
and then in:  http://marc.info/?l=linux-video&m=122264501207938&w=2
you wrote:
> The HDTVwonder is partially working - the digital ATSC input works,
> while the
> analogue NTSC input does not. If anyone can deny the bit about the 
> analogue tuner, I'd love to hear about it (because I can't get it 
> working!).
>   

Lee, did you try scanning for analog channels on both RF inputs ?  What
is written on the PCI riser applies to the expected operation under a
Windows environment.  Under Linux, this may differ.  In fact, going
beyond the default behaviour one may observe under Linux, note that
mkrufky also added an option for dual RF input devices so that the user
can specify which input they want used for analog and digital. See
"modinfo tuner-simple"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
