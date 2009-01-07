Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07GvEXZ014503
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 11:57:14 -0500
Received: from www.seiner.com (flatoutfitness.com [66.178.130.209])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n07Gv1Vo029594
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 11:57:01 -0500
Message-ID: <38622b973a864018a37f32b60f618d9b.squirrel@www.datavault.us>
In-Reply-To: <20090107164700.DW3G9.1910.root@cdptpa-web12-z01>
References: <20090107164700.DW3G9.1910.root@cdptpa-web12-z01>
Date: Wed, 7 Jan 2009 08:56:59 -0800 (PST)
From: "Yan Seiner" <yan@seiner.com>
To: marilynnpg@tx.rr.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Windows vs Linux  DVR System?
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


On Wed, January 7, 2009 8:47 am, marilynnpg@tx.rr.com wrote:
> I am looking into building my own DVR system on my PC running either
> Windows Vista or XP and one of the applications listed below.  That said,
> before I proceeded I wanted to check to see if there was a Linux
> application which will allowed me to use multiple Logitec QuickCam Pro
> cameras (approx 8 cameras).  In addition, I would be grateful if some
> could point out the advantages of using a Linux based solution over one of
> the Windows based solutions listed below.

That many USB cameras will need some hefty CPU.  I've not had much luck
with webcams.  You might want to consider IP cams; you can find them for
not much more than webcams.  Or go with plain old wired cameras and a
capture board.

As for linux v. windows, I've tried to work with the windows based DVR
systems, and pretty much without exception they're a PITA.   (OK, I like
linux but still....)  Mostly the apps are clunky, complicated, very
difficult to set up properly, and are always missing some key (to me)
feature.

With linux, you set up your cameras and make sure they work.  It doesn't
matter if they're webcams, IPcams, or capture boards.

Then install and configure motion, one thread per camera.

If you want movies, you can either set up motion to do that or you can use
ffmpeg and generate flash movies directly.

And then use a browser.

See my website - http://www.seiner.com - and look at the snakecam and
lizardcam.  They're pretty dull as I don't have the cameras set up
correctly ATM but it uses the above setup.  motion captures the motion,
ffmpeg rotates each frame to portrait from landscape, generates the movie
using the last 1440 frames, and some more scripts post it on the website,
with updates every hour.

--Yan

>
> 1) Capturix VideoSpy beta 6
> ----------------------------------
> http://www.pcmag.com/article2/0,2817,475790,00.asp
> http://www.capturix.com/default.asp?product=cvs
>
>
> 2) Gotcha! 3.6
> ------------------
> www.gotchanow.com
> http://www.pcmag.com/article2/0,2817,475791,00.asp
>
>
> 3) WebCam Watchdog 2.2
> --------------------------------
> http://www.pcmag.com/article2/0,2817,475793,00.asp
> www.webcam123.com
>
>
> 4) Watcher and RemoteView
> -----------------------------------
> www.digi-watcher.com
> http://www.pcmag.com/article2/0,2817,475792,00.asp
>
>
> 5) Cam Wizard
> ------------------
> http://www.ledset.com/camwiz/index.htm
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
> !DSPAM:4964dca861061804284693!
>
>


-- 
  o__
  ,>/'_          o__
  (_)\(_)        ,>/'_        o__
Yan Seiner      (_)\(_)       ,>/'_     o__
       Personal Trainer      (_)\(_)    ,>/'_        o__
             Professional Engineer     (_)\(_)       ,>/'_
Who says engineers have to be pencil necked geeks?  (_)\(_)

You are an adult when you realize that everyone's an idiot sometimes. You
are wise when you include yourself.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
