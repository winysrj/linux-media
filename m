Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RIPexq024552
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 14:25:40 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RIPQmN020983
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 14:25:27 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2974355rvb.51
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 11:25:26 -0700 (PDT)
Message-ID: <d9def9db0805271125o6a231616x1134f7c2a11e0a8d@mail.gmail.com>
Date: Tue, 27 May 2008 20:25:26 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Collin Day" <dcday137@gmail.com>
In-Reply-To: <cb70ae690805271050h111e8d42oeda95e5e93ab036a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb70ae690805271050h111e8d42oeda95e5e93ab036a@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Kworld USB2800 Device - how do I get it working - em28xx driver?
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

Hi,

On Tue, May 27, 2008 at 7:50 PM, Collin Day <dcday137@gmail.com> wrote:
> Hi all -
>
> I apologize if this has been answered, but I am new and don't know where to
> search the list at.  I have a Kworld USB2800 DVD Maker.  I have not been
> able to get it to work at all.  I am in N. America, so I am using NTSC.
> Anyway, I looked in the em28xx-cards.c file and found the
> [EM2800_BOARD_KWORLD_USB2800].  I am not positive, but I took mine apart and
> it has a NXP SAA7113h chip and a em2860 chip.  First off, I am assuming
> (oplease correct me if I am wrong anywhere) that I need the SAA7115.ko
> module and the em28xx module.  Next, I noticed that the .norm only lists
> PAL_BG and that is the only norm listed.  Is it as simple as changing the
> .em_type to EM2860, changing hass tuner to 0 (it is only a video capture
> device, there is no tuner) and adding the NTSC norm, revcompiling and
> installing?  This has really been bothering me and even though I have read
> that others have been successful with this device some how.
>
> lsusb info:
>
> Bus 001 Device 005: ID eb1a:2860 eMPIA Technology, Inc.
>
> using parameter card=13 when I load the module, it tells me that it finds
> everything.
>
> The device is a Kworld VS-USV2800D.
>

did you try to follow the instruction on mcentral.de?

-Markus

> If there is any other info I can provide, please let me know and I will post
> it.  Thank you!
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
