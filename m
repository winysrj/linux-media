Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n36EGKWp027412
	for <video4linux-list@redhat.com>; Mon, 6 Apr 2009 10:16:20 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n36EFaEh001054
	for <video4linux-list@redhat.com>; Mon, 6 Apr 2009 10:16:00 -0400
Received: by mail-gx0-f171.google.com with SMTP id 19so4604051gxk.3
	for <video4linux-list@redhat.com>; Mon, 06 Apr 2009 07:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DA0B1E.3010704@linuxtv.org>
References: <49D20B0B.1030701@australiaonline.net.au>
	<49D227A3.5000601@linuxtv.org>
	<49D2FE07.5060906@australiaonline.net.au>
	<49D60DA2.5040904@australiaonline.net.au>
	<49DA0B1E.3010704@linuxtv.org>
Date: Mon, 6 Apr 2009 10:16:00 -0400
Message-ID: <412bdbff0904060716y44bd932cm81ca214425bdf355@mail.gmail.com>
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

On Mon, Apr 6, 2009 at 10:01 AM, Steven Toth <stoth@linuxtv.org> wrote:
> Yes and no, they're largely the same. For some reason I thought we'd used
> the 3028 firmware with the 3008 in the past, maybe this no longer holds. up.
>
> I'm surprised you're seeing the "Incorrect readback of firmware version"
> error.
>
> Would any xc3028 guru's like to comment?
>
> - Steve

I would have to look at the code, but my first guess would probably be
a combination of the tuner still being held in reset along with not
properly detecting a the failure to read the register on the i2c bus
(failing silently).

Can we get a full pastebin of the dmesg output from bootup? (the dmesg
sent was truncated by the user)

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
