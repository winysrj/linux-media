Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BEjg68002229
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:45:42 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6BEivNi002158
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:44:58 -0400
From: Rainer Koenig <Rainer.Koenig@gmx.de>
To: Alex Hixon <hixon.alexander@mediati.org>
Date: Fri, 11 Jul 2008 16:44:50 +0200
References: <200807101924.58802.Rainer.Koenig@gmx.de>
	<aae5e9b33584111fbf6db53272b5cb5a@localhost>
In-Reply-To: <aae5e9b33584111fbf6db53272b5cb5a@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111644.51110.Rainer.Koenig@gmx.de>
Cc: video4linux-list@redhat.com
Subject: Re: Flipping the video from webcams
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

Hi Alex,

Am Freitag, 11. Juli 2008 01:56 schrieb Alex Hixon:
> You didn't really mention what version of the driver you're running, an

0.11.0 should be. It was the latest from http://wiki.mediati.org/R5u870
but now this site is not reachable for the moment. 

> on what device, so I can't really help you specifically. In an earlier

Vendor-ID was Ricoh, Device-ID is 1841.

> version of the driver, there was a bug where by default we wouldn't turn
>
> on the V-Flip control by default.

Yes, I saw in the source that for one device-id they had a Default flip.

> You should still just be able to turn on/off the V-Flip control in any
>
> V4L2 application that supports them (eg xawtv).

ACK. Problem is that Kopete doesn't offer flip controls. So I need to find a 
way of flipping the picture in the driver. 

> Also, considering that the r5u870 driver hasn't been merged upstream yet,
>
> you might want to try emailing on the r5u870 list (you can signup at
>
> http://lists.mediati.org). 

Well, I have the things at work, so next possible date to get logs and error 
messges directly from the machine is monday. Maybe by then midiati.org is up 
again. 

Thanks and have a nice weekend
Rainer
-- 
Rainer Koenig, Diplom-Informatiker (FH), Augsburg, Germany

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
