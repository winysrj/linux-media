Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2KK2hq2011425
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:02:43 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2KK2PYb006548
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 16:02:25 -0400
Received: by gxk19 with SMTP id 19so3298840gxk.3
	for <video4linux-list@redhat.com>; Fri, 20 Mar 2009 13:02:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237578912.26159.13.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
	<412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	<1237578912.26159.13.camel@T60p>
Date: Fri, 20 Mar 2009 16:02:25 -0400
Message-ID: <412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	grabbers
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

On Fri, Mar 20, 2009 at 3:55 PM, Mikhail Jiline <misha@epiphan.com> wrote:
>> Is this patch incomplete?  Where is the registration for the USB ID of
>> the device?
>
> The patch is complete. This device (as many others) doesn't have unique
> VID/PID, it uses generic eb1a:2821, which is already associated with
> ex28xx (see drivers/media/video/em28xx/em28xx-cards.c:1103)
>
> Regards,
> Misha.

Yeah, something still seems wrong here.  In cases where the device
uses one of the Empia generic USB ids, you need to have either an i2c
hash entry of an eeprom hash entry.  That's how it knows which device
to associate it with in those cases.

Did you try this patch?  If so, can you send the full dmesg output
after connecting the device?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
