Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BEaeEo027398
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:36:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6BEaOaG029382
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 10:36:25 -0400
From: Rainer Koenig <Rainer.Koenig@gmx.de>
To: Thierry Merle <thierry.merle@free.fr>
Date: Fri, 11 Jul 2008 16:36:16 +0200
References: <200807101924.58802.Rainer.Koenig@gmx.de>
	<48766A75.7060903@free.fr>
In-Reply-To: <48766A75.7060903@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111636.17040.Rainer.Koenig@gmx.de>
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

Hi Thierry,

Am Donnerstag, 10. Juli 2008 22:00 schrieb Thierry Merle:
> You may put the laptop upside down :)

;-) Will not be accepted due to a violation of ergonmic principles :-)

> Seriously, Andreas Demmer reported success on image flipping using
> vloopback+camsource.
> I think on his blog you will find the information:
> http://www.andreas-demmer.de/weblog/beitrag229/
> but I don't understand German sadly...

Well I understand German, I tried out but I failed. The strange thing
is that Kopete has no problem to read the video device /dev/video0, but both 
camsource and gqcam fail to read from the device. The camstream log is just 
filled with error messages. I'm afraid that the r5u870 driver (version 
0.11.0, the latest from the site that is donw since this lunchtime :-() is 
not implementing all. v4lctl also shows some error messages when querying or 
trying to capture images.

Thanks for the hint anyway, I'll keep on searching.

Regards
Rainer
-- 
Rainer Koenig, Diplom-Informatiker (FH), Augsburg, Germany

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
