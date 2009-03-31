Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2VEXdQl006709
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 10:33:39 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2VEW2pD019901
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 10:32:02 -0400
Received: by gxk19 with SMTP id 19so5417906gxk.3
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 07:32:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D227A3.5000601@linuxtv.org>
References: <49D20B0B.1030701@australiaonline.net.au>
	<49D227A3.5000601@linuxtv.org>
Date: Tue, 31 Mar 2009 10:32:02 -0400
Message-ID: <412bdbff0903310732n3d767d0cy46933a8a446ae3e4@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

On Tue, Mar 31, 2009 at 10:24 AM, Steven Toth <stoth@linuxtv.org> wrote:
> ... and it may not have a xc3028 onboard, or may have the low power version
> which is why the firmware fails to load. A few other things come to mind but
> given that the vendor has switch subid details, it's probably best to cross
> reference with the wiki to ensure it still has the same parts.

If it does have the low power version on board (the xc3028L), do *not*
load the regular firmware or else you will burn out the chip.

> Assuming the wiki entry truly doesn't exist, maybe you could create it with
> the newer rev details, maybe with some pictures and component details?

If it's a brand new board, you should definitely take some pictures
before trying the regular xc3028 firmware.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
