Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07HKBJS030606
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:20:11 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n07HJq2i017314
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:19:53 -0500
Received: by wa-out-1112.google.com with SMTP id j4so4682923wah.19
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 09:19:52 -0800 (PST)
Message-ID: <26aa882f0901070919t4820e888kc57c8cde9860a7d7@mail.gmail.com>
Date: Wed, 7 Jan 2009 12:19:52 -0500
From: "Jackson Yee" <jackson@gotpossum.com>
To: video4linux-list@redhat.com
In-Reply-To: <38622b973a864018a37f32b60f618d9b.squirrel@www.datavault.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090107164700.DW3G9.1910.root@cdptpa-web12-z01>
	<38622b973a864018a37f32b60f618d9b.squirrel@www.datavault.us>
Subject: Re: Windows vs Linux DVR System?
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

I second Yan's suggestion for analog cameras and a capture board if
you're looking for consistent, quality pictures. Eight USB webcams are
possible if you have separate USB hub chips and a good motherboard,
but you're really stretching the hardware thin once you get past four.
IP cameras are great if you have lots of money to burn, but start
struggling in numbers above eight even on gigabit ethernet due to
bandwidth contention and are not anywhere close to analog systems in
terms of price (The h264 cameras do a decent job, but you can setup an
entire analog system for the price of one).

I've honestly hated most of the surveillance solutions that I've ran
across with Windows, although I have been impressed with Media Center.
The Linux ones are in their infancy as far as enterprise features are
concerned, but what they do already, they do well, and you can always
hack together a quick feature when you need it. Good luck trying to
change any of the Windows solutions to fit your needs.

I suggest getting some good quality analog cameras along with a Linux
card from bluecherry.net, then installing either Zoneminder or motion
on a good energy-efficient dual-core machine (the 45W Athlon X2s are
my favorite at the moment). You'll be saving yourself a good bit of
money, and you can upgrade in five years when IP cameras are priced
lower.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Wed, Jan 7, 2009 at 11:56 AM, Yan Seiner <yan@seiner.com> wrote:
> That many USB cameras will need some hefty CPU.  I've not had much luck
> with webcams.  You might want to consider IP cams; you can find them for
> not much more than webcams.  Or go with plain old wired cameras and a
> capture board.
>
> As for linux v. windows, I've tried to work with the windows based DVR
> systems, and pretty much without exception they're a PITA.   (OK, I like
> linux but still....)  Mostly the apps are clunky, complicated, very
> difficult to set up properly, and are always missing some key (to me)
> feature.
>
> With linux, you set up your cameras and make sure they work.  It doesn't
> matter if they're webcams, IPcams, or capture boards.
>
> Then install and configure motion, one thread per camera.
>
> If you want movies, you can either set up motion to do that or you can use
> ffmpeg and generate flash movies directly.
>
> And then use a browser.
>
> See my website - http://www.seiner.com - and look at the snakecam and
> lizardcam.  They're pretty dull as I don't have the cameras set up
> correctly ATM but it uses the above setup.  motion captures the motion,
> ffmpeg rotates each frame to portrait from landscape, generates the movie
> using the last 1440 frames, and some more scripts post it on the website,
> with updates every hour.
>
> --Yan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
