Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ICxtUr015433
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 08:59:55 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ICxelw009212
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 08:59:41 -0400
Received: by ug-out-1314.google.com with SMTP id s2so54539uge.6
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 05:59:40 -0700 (PDT)
Message-ID: <412bdbff0807180559j79e5a82y1624773e45a74f41@mail.gmail.com>
Date: Fri, 18 Jul 2008 08:59:40 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "John Ortega" <jortega@listpropertiesnow.com>
In-Reply-To: <EEEHJJMABEBDCNKAINKCKEMGCHAA.jortega@listpropertiesnow.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487FC316.30306@b4net.dk>
	<EEEHJJMABEBDCNKAINKCKEMGCHAA.jortega@listpropertiesnow.com>
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV Remote
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

On Fri, Jul 18, 2008 at 1:17 AM, John Ortega
<jortega@listpropertiesnow.com> wrote:
> Hello,
>
> Does anyone have the remote working for the Pinnacle PCTV usb device. I've
> got the TV working. But, the remote doesn't work at all.
>
> Thanks,
> John

If you're talking about the Pinnacle PCTV HD Pro Stick (800e), then I
can tell you outright that the remote control support is not
implemented.

I have wrote some code for it but never got around to getting it fully
debugged or checking it in.

I'm pretty sure Markus's em28xx driver does support it though
(mcentral.de), although I've never tried it myself.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
