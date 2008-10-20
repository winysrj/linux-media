Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9K5kqi4001315
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 01:46:52 -0400
Received: from hermes.gsix.se (hermes.gsix.se [193.11.224.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9K5kc10004031
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 01:46:39 -0400
Received: from dng-gw.sgsnet.se ([193.11.230.69] helo=[172.16.172.22])
	by hermes.gsix.se with esmtp (Exim 4.63)
	(envelope-from <jonatan@akerlind.nu>) id 1KrnbB-0008Jl-QH
	for video4linux-list@redhat.com; Mon, 20 Oct 2008 07:46:37 +0200
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
In-Reply-To: <48FA41C1.3030501@b4net.dk>
References: <48F90ED4.8030907@b4net.dk>
	<alpine.DEB.1.10.0810181408370.18626@vegas> <48FA41C1.3030501@b4net.dk>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Oct 2008 07:46:34 +0200
Message-Id: <1224481594.4265.8.camel@skoll>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: Hauppauge PVR-150 MCE vs HVR-1300
Reply-To: video4linux-list@redhat.com
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

On lör, 2008-10-18 at 22:06 +0200, Per Baekgaard wrote:
> So another way of putting my question is really whether the HVR-1300
> would work equally well (since it is roughly the same price here, and
> appears to support also DVB-T)?

I have the HRV-1300 in a VIA EPIA based system running mythtv. So far I
have only tested the analog part (does not have dvb-t reception/antenna
yet). 

> >From the resources linked, it appears to not yet have MPEG encoder support.
> 
> However, from earlier mails here and elsewhere, it appears that some
> people may have MPEG HW encoder support working -- but  additionally,
> some are reporting problems with it under MythTV, so I was hence
> wondering which is it...
> 
> Is the HVR-1300 MPEG encoder HW support in place now? Do a lot/at least
> some have it working well in their setup, using either Analog or DVB-T?

Well, the HW encoder is sort of working. The problem is that I cannot
change channel (tuning) when reading the mpeg stream. I also have a
problem with the audio being interupted about every 5 seconds with a
loud static noice and then resuming to normal. 

I haven't really put the time and effort into this part (the TV-card) of
the setup, so at the moment I only have the MPEG device mapped in
mythtv. Previously I tried the unencoded device node and that seemed to
work, but unfortunately my system is too slow to recode this and re-read
it for display to wath live-tv. Will probably revert to using the
unencoded device since we don't use the system for livetv.

For information, system currently runs these software versions:
v4l-dvb from mercurial (last checkout was September 28)
gentoo based system with kernel 2.6.25-tuxonice-r6
media-tv/mythtv-0.20.2_p15634

/Jonatan


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
