Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2GFscCR030256
	for <video4linux-list@redhat.com>; Tue, 16 Mar 2010 11:54:38 -0400
Received: from mail-bw0-f225.google.com (mail-bw0-f225.google.com
	[209.85.218.225])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2GFsRGl004505
	for <video4linux-list@redhat.com>; Tue, 16 Mar 2010 11:54:27 -0400
Received: by bwz25 with SMTP id 25so88074bwz.31
	for <video4linux-list@redhat.com>; Tue, 16 Mar 2010 08:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B9FA8FA.30204@saturnus.nl>
References: <4B9FA07B.3000206@bysky.nl>
	<829197381003160834k7e82cd6am5cf8153e3e5625b2@mail.gmail.com>
	<4B9FA8FA.30204@saturnus.nl>
Date: Tue, 16 Mar 2010 11:54:25 -0400
Message-ID: <829197381003160854h77f4a193y3d426ca69fa6ba19@mail.gmail.com>
Subject: Re: Any update on em28xx on igevp2 ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Gert-Jan de Jonge <de_jonge@saturnus.nl>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, Mar 16, 2010 at 11:51 AM, Gert-Jan de Jonge
<de_jonge@saturnus.nl> wrote:
> Hi Devin,
>
> thanks for the quick reply. My first choice is not the em28xx on the igepv2,
> unfortunately i could not get any other usb devices at this moment. Maybe
> there will be more interest for these devices on arm, because of expected
> rise of arm laptops and other consumer devices, which will not al have
> analog video input:)
>
> Parallel to this device I am also working on the vss3530 and the hawkboard,
> which both have their own problems, but already have analog video input
> on-board.
>
> So if you have any tips on what i could try to debug this problem, i am
> welcome to work on it.
>
> If you have a tip on an analog input device better suited for arm, pleas let
> me know.

I did some work on em28xx/ARM last year, so it *was* working at least
with the ARM platform I had been loaned for testing.  So either a
regression got introduced or it's something weird about that hardware.

At this point you'll probably just have to add printk() statements to
the driver and grind it out until you identify the issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
