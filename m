Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o23Eufvc021544
	for <video4linux-list@redhat.com>; Wed, 3 Mar 2010 09:56:41 -0500
Received: from mail-fx0-f216.google.com (mail-fx0-f216.google.com
	[209.85.220.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o23EuRkk008818
	for <video4linux-list@redhat.com>; Wed, 3 Mar 2010 09:56:28 -0500
Received: by fxm8 with SMTP id 8so1554188fxm.11
	for <video4linux-list@redhat.com>; Wed, 03 Mar 2010 06:56:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267621938.3066.46.camel@chimpin>
References: <1267621938.3066.46.camel@chimpin>
Date: Wed, 3 Mar 2010 09:56:27 -0500
Message-ID: <829197381003030656q6b5cf73eybcf30b713ba9be37@mail.gmail.com>
Subject: Re: em28xx v4l-info returns gibberish on igepv2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John Banks <john.banks@noonanmedia.com>
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

On Wed, Mar 3, 2010 at 8:12 AM, John Banks <john.banks@noonanmedia.com> wrote:
> I have an usb capture card that accepts composite and svideo and outputs
> raw video through v4l2.
>
> When running the card on my laptop (ubuntu karmic) I am able to use
> gstreamer to dump the raw video to a file. It comes out as yuv and can
> be easily played back.

Hi John

I saw your question on #linuxtv yesterday, and reached out to you but
I guess you didn't see the message.

I did some ARM work for the em28xx last year, and assuming there has
been no regression, it should be working fine.  The fact that even the
enumstd ioctl is returning zero'd data suggests that you've got some
sort of basic userland/kernel communications problem, since that
command has no interaction with the hardware at all (the driver fills
out the result with statically defined data).  It might also be some
sort of bug in v4l2-info.

Have you tried writing a quick 50-line C program that performs the
ioctl and dumps the result?  That might help you narrow down whether
it's a v4l2-info problem.

Without a board though, I'm not quite sure how I could debug this.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
