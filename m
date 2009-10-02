Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n92GeGPn009945
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 12:40:16 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92Ge3Vx010644
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 12:40:03 -0400
Received: by bwz5 with SMTP id 5so1123819bwz.3
	for <video4linux-list@redhat.com>; Fri, 02 Oct 2009 09:40:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC5FA6E.2000201@tmr.com>
References: <4AC5FA6E.2000201@tmr.com>
Date: Fri, 2 Oct 2009 12:40:02 -0400
Message-ID: <829197380910020940o599f5678t60abb2b2da6f8d46@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Upgrading from FC4 to current Linux
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

On Fri, Oct 2, 2009 at 9:04 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> I am looking for a video solution which works on recent Linux, like
> Fedora-11. Video used to be easy, plug in the capture device, install xawtv
> via rpm, and use. However, recent versions of Fedora simply don't work, even
> on the same hardware, due to /dev/dsp no longer being created and the
> applications like xawtv or tvtime still looking for it.
>
> The people who will be using this are looking for hardware which is still
> made and sold new, and software which can be installed by a support person
> who can plug in cards (PCI preferred) or USB devices, and install rpms. I
> maintain the servers on Linux there, desktop support is unpaid (meaning I
> want a solution they can use themselves).
>
> We looked at vlc, which seems to want channel frequencies in kHz rather than
> channels, mythtv, which requires a database their tech isn't able (or
> willing) to support, etc.
>
> It seems that video has gone from "easy as Windows" 3-4 years ago to
> "insanely complex" according to to one person in that group who wanted an
> upgrade on his laptop. There is some pressure from Windows users to mandate
> Win7 as the desktop, which Linux users are rejecting.
>
> The local cable is a mix of analog channels (for old TVs) and clear qam. The
> capture feeds from the monitor system are either S-video or three wire
> composite plus L-R audio. Any reasonable combination of cards (PCI best,
> PCIe acceptable), USB device, and application which can monitor/record would
> be fine, but the users are not going to type in kHz values, create channel
> tables, etc. They want something as easy to use as five years ago.
>
> Any thoughts?
>
> --
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot

I took a few minutes and put together a response to your email,
outlining the issues.  Feel free to check it out here:

http://www.kernellabs.com/blog/

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
