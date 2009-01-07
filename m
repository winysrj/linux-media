Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07Ha35Z007260
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:36:03 -0500
Received: from www.seiner.com (flatoutfitness.com [66.178.130.209])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n07HYjRF014078
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:34:46 -0500
Message-ID: <92538dce1e736997ab82c7a9b2787600.squirrel@www.datavault.us>
In-Reply-To: <26aa882f0901070919t4820e888kc57c8cde9860a7d7@mail.gmail.com>
References: <20090107164700.DW3G9.1910.root@cdptpa-web12-z01>
	<38622b973a864018a37f32b60f618d9b.squirrel@www.datavault.us>
	<26aa882f0901070919t4820e888kc57c8cde9860a7d7@mail.gmail.com>
Date: Wed, 7 Jan 2009 09:34:44 -0800 (PST)
From: "Yan Seiner" <yan@seiner.com>
To: "Jackson Yee" <jackson@gotpossum.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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


On Wed, January 7, 2009 9:19 am, Jackson Yee wrote:
> I second Yan's suggestion for analog cameras and a capture board if
> you're looking for consistent, quality pictures. Eight USB webcams are
> possible if you have separate USB hub chips and a good motherboard,
> but you're really stretching the hardware thin once you get past four.

Webcams are built for indoor light levels; they wash out in daylight and
have poor low-light performance.  They're limited to 14' cable runs.  They
have poor frame rates at higher (640x480) resolutions - as low as 3 fps. 
Their one advantage is that some of them can be easily modified for IR and
are very sensitive so that even a few 20mw LEDs can provide good
performance.

> IP cameras are great if you have lots of money to burn, but start
> struggling in numbers above eight even on gigabit ethernet due to
> bandwidth contention and are not anywhere close to analog systems in
> terms of price (The h264 cameras do a decent job, but you can setup an
> entire analog system for the price of one).

All too true.  I've been cherry-picking my IPcams and I've been able to
find them for $60-70 but they're few and far between and the choices are
limited.  I get around the bandwith issue by having motion poll them but
that limits me to around 5 fps.  With luck and a good camera I get 12 fps
@ 640x480 but not often.

There's nothing like a good hardware capture board and analog cameras. 
You get much better choices, interchangeable lenses, good light
sensitivity, and so on.

--Yan

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
