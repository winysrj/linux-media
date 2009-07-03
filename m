Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n63KEpUF018578
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 16:14:51 -0400
Received: from mail-qy0-f180.google.com (mail-qy0-f180.google.com
	[209.85.221.180])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n63KEZPE004477
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 16:14:35 -0400
Received: by qyk10 with SMTP id 10so1279519qyk.23
	for <video4linux-list@redhat.com>; Fri, 03 Jul 2009 13:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <h2lgu9$r6b$1@ger.gmane.org>
References: <h2lgu9$r6b$1@ger.gmane.org>
Date: Fri, 3 Jul 2009 16:14:35 -0400
Message-ID: <829197380907031314q4829787cu7d7c6cf35a006377@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jim Henderson <hendersj@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle 880e Development?
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

On Fri, Jul 3, 2009 at 1:59 PM, Jim Henderson<hendersj@gmail.com> wrote:
> Hi,
>
> I thought I'd seen something on this list in the last couple of months
> about development for the 880e moving forward - according to the wiki
> support for this device is in "active development" - just wondering if
> there's been any progress and if there are any drivers available for
> testing yet?
>
> Thanks,
>
> Jim

Hello Jim,

I was doing the 880e support, but got sidetracked with the HVR-950q
analog support.  In addition, the product got discontinued, I ran into
licensing issues with ATI/AMD/Broadcom over the digital demodulator
driver, and there were pretty much no other products out there that
would have benefited from the saa7136 driver.

In other words, it didn't make much sense to put more effort into a
discontinued product where the chipset supported needed didn't help
any other products.  My time is just better spent working on other
things.

I've had a couple of people ask about support for this device
recently.  I pretty much had the analog video support working on all
three inputs (tuner/composite/s-video), although the driver was
nowhere near a state where it could be merged upstream.  I considered
making the tree available in its current state, but I wasn't sure how
useful it would be to people without the digital support and I hadn't
gotten the audio working yet.

If there were a developer experienced with v4l2 that had an active
interest in doing the rest of the work, they can contact me and we
might be able to work something out (although I cannot provide any of
the datasheets since they are under NDA).

There just aren't enough hours in the day....

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
