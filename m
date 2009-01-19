Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0J25Hnb020610
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 21:05:17 -0500
Received: from smtp124.rog.mail.re2.yahoo.com (smtp124.rog.mail.re2.yahoo.com
	[206.190.53.29])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0J24dHF020835
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 21:04:58 -0500
Message-ID: <4973DFB4.5040509@rogers.com>
Date: Sun, 18 Jan 2009 21:04:36 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Jocke <maillist@jarkeborn.se>
References: <4973174A.30406@jarkeborn.se>
In-Reply-To: <4973174A.30406@jarkeborn.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Removed drivers...help
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

Jocke wrote:
> Hello,
>
> I have a fresh Ubuntu Server 8.10 and it had support for my DVB cards
> but since I have used the latest v4l-dvb drivers before I did the same
> this time.
>
> I am struggeling with my TV cards and tried with the latest v4l-dvb
> source/firmware and from a v4l-dvb perspective it looked fine. However
> I have problem with opensascng so I wanted to revert to the default
> v4l-dvb drivers to see if that work.
>
> So I executed "make rminstall" but that seems to remove all video
> drivers :(
>
> - How can I get back to the default Ubuntu drivers?
>
> Best Regards 

Reinstall your kernel from your distro's repos.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
