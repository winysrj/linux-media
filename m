Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n65N71qH026405
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 19:07:01 -0400
Received: from mail-ew0-f220.google.com (mail-ew0-f220.google.com
	[209.85.219.220])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n65N6i1V027086
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 19:06:44 -0400
Received: by ewy20 with SMTP id 20so4071922ewy.3
	for <video4linux-list@redhat.com>; Sun, 05 Jul 2009 16:06:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A511E18.2010305@gmail.com>
References: <4A5089CF.3070606@gmail.com>
	<26aa882f0907051330y6f092ca3x18e1f58e883352d4@mail.gmail.com>
	<4A511E18.2010305@gmail.com>
Date: Sun, 5 Jul 2009 19:06:44 -0400
Message-ID: <26aa882f0907051606x9b9f63bi6a7a9d5ea7db6126@mail.gmail.com>
From: Jackson Yee <jackson@gotpossum.com>
To: fsulima <fsulima@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Please advise: 4channel capture device with HW compression for
	Linux based DVR
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

Yep, been down that road before myself.

The truth of the matter is that slim profile, multiple port cards are
available with Linux drivers, but they are quite expensive ($500 for
the cheapest that I could find, although it is a very nice looking 16
port system).

I have a mini-ITX system sitting by my television right now which I
would love to use my new STK-1160 4-port USB adapter (marketed as
EasyCap 4-port DVR USB) with, but unfortunately, we're still working
out NTSC support for it. The guys using PAL and Zoneminder have
apparently gotten it to work pretty well.

I've never used an Atom system, but from what I understand, although
the CPU is quite power efficient, it is also utterly crushed in
performance by the cheapest dual-cores available today. That's why
Nvidia's Ion platform was so attractive to people looking to do 720p
or 1080p on their televisions - the Atom simply did not have the power
to handle HD video. A D1 stream is much easier to work with, but
encoding is also more processor intensive than decoding by an order of
magnitude. You could probably do one D1 stream with MPEG4, but if you
plan on using real-time x264 or more than one stream... I would have
to believe that your system would be quite incapable of keeping up the
framerate.

Believe me, I would love to say that I have a solution for you since
that would mean a solution for me as well, but the reality of the
matter is that we are just not quite there yet on driver support for a
multiple channel USB capture device. If you're just planning on doing
one D1 stream at a time, the WinTV PVR USB2 has hardware encoding and
is supported quite well. I suppose that you could hook up a couple of
these, but whether the system could handle these USB devices is beyond
my experience.

Please let me know if you have any success with this project.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Sun, Jul 5, 2009 at 5:41 PM, fsulima<fsulima@gmail.com> wrote:
> Hi Jackson.
>
> Thanks for the answer.
> The first thing I realized when I learned how to use search on the mailing
> list was that this question is very common so I was already preparing to
> shot myself expecting the hear the advice to learn to use search. :) It's a
> shame.
> Ok, back to the point...
>
> The problem here is that I have a little unconventional hardware: it is a
> small form factor Intel D945GCLF2D mini-ITX Motherboard + integrated Intel
> Atom 330 2core 1.6Ghz. I have doubts about it's ability to encode 4 channels
> of D1, besides Intel advertises Atom's performance as video encoder:
> http://www.intel.com/design/intarch/applnots/DSS_Appnote_r5.pdf.
> I really don't want to setup another device specifically for DVR, especially
> with large form factor. Installing cheap capture device w/o h/w compression
> sounds like a great option, but I'd really like to be sure that Atom 330 is
> capable enough for this. Is there any expertise on this?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
