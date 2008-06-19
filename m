Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JFJpF6007140
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 11:19:51 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JFJPEL019726
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 11:19:25 -0400
Received: from webmail.xs4all.nl (dovemail14.xs4all.nl [194.109.26.16])
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id m5JFJOdw057279
	for <video4linux-list@redhat.com>;
	Thu, 19 Jun 2008 17:19:25 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <23809.62.70.2.252.1213888764.squirrel@webmail.xs4all.nl>
Date: Thu, 19 Jun 2008 17:19:24 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Looking for a well suppord TV card with some requirements
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

> Hi,
>
> I am looking for a well support TV card with the following feature list:
>
>    - Must have at least one tuner (PAL), preferably two
>    - Must have composite input (for connecting a Nintendo Wii)
>    - Should not have any delay between input signal and output
>    - Works on kernel 2.6.18 (either vanilla, or by adding a driver)
>    - Additionally, DVB-T would be nice
>
> I bought a Hauppauge PVR-150 because I thought it complied to the above,
> but apparently (because it is an MPEG encoder and not a real TV card)
> there was a 2 second delay between the image from the Wii and the output
> on screen which is unacceptable for playing games.

Before you buy something else, read this thread on how to avoid the 2
second delay with a PVR-150:

http://www.gossamer-threads.com/lists/ivtv/devel/36688

Regards,

       Hans

>
> (And the sound didn't work, but I didn't try to look for a solution
> because of the delay)
>
> I still have an old Hauppauge WinTV card from 2000, based on the bttv
> driver which works fine, but does not have composite input.
>
> Who can help me find something acceptable ?
>
> --
> --   dag wieers,  dag@wieers.com,  http://dag.wieers.com/   --
> [Any errors in spelling, tact or fact are transmission errors]
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
