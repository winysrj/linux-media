Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJOI84012413
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:24:18 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALJO3JW022340
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:24:03 -0500
Received: by ug-out-1314.google.com with SMTP id j30so208861ugc.13
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 11:24:02 -0800 (PST)
Message-ID: <412bdbff0811211124t21332eaer602fa807f0436a9d@mail.gmail.com>
Date: Fri, 21 Nov 2008 14:24:02 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
In-Reply-To: <alpine.DEB.1.10.0811212015070.29615@bakacsin.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811212015070.29615@bakacsin.ki.iif.hu>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

On Fri, Nov 21, 2008 at 2:20 PM, Kiss Gabor (Bitman)
<kissg@ssg.ki.iif.hu> wrote:
> Uhm.... every time I tried to snoop USB traffic windows machine
> got frozen or slowed veeeeeeeeeeery down.
> So I could not run TV software bundled with device.
> A very short (182 kB) capture about device connection is here:
>
> http://bakacsin.ki.iif.hu/~kissg/tmp/connect-UsbSnoop.log.txt

I'll look at this and see if enough is here to debug the issue.

> A question:
> Where should I download latest em28xx driver from?
> http://linuxtv.org/hg/ or http://mcentral.de/hg/ ?

There are actually two different em28xx drivers.  The driver on
linuxtv.org is maintained by the linux-dvb project and is the driver
that currently appears in the mainline kernel.  The mcentral.de driver
is maintained by Markus Rechberger and any questions regarding that
driver should be sent to his "em28xx" mailing list hosted on
mcentral.de.

Thanks for the additional testing,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
