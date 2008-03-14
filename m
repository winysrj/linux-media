Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EKJ6Hq002806
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 16:19:06 -0400
Received: from web56407.mail.re3.yahoo.com (web56407.mail.re3.yahoo.com
	[216.252.111.86])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2EKIYC5022441
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 16:18:34 -0400
Date: Fri, 14 Mar 2008 13:18:28 -0700 (PDT)
From: r bartlett <techwritebos@yahoo.com>
To: Markus Rechberger <mrechberger@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <d9def9db0803140943h47a3998ere7400ea26b903a07@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <763245.5074.qm@web56407.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: Another very basic question...
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

I've got a WinTV-HVR-1800, which has an analog tuner and a ATSC/QAM tuner.  The analog side seems to not yet be supported (It works -- I can boot to Vista and watch the analog side) by Linux, but I was wondering whether I can tweak my channels.conf or something and get more digital channels.

I'm kind of new to the various ATSC, QAM, NTSC_M stuff.  My assumption up to this point has been that if I want to watch the full range of channels (1-120) or something, I need to do it through analog.

My system is Comcast Digital cable with OnDemand, a Comcast-supplied box (looks small, like a router, not a PVR) and remote control (neither of which I'm currently using), and a Y-split cable line that goes directly to my tv card.  Currently I'm seeing things like NBC, CBS, ABC, PBS (a few channels), FOX, CW...and a few local stations.  If it's also possible to tune to Food Network, Sci-fi, Cartoon Network, etc, that would be great.  These stations come in fine on my regular television with no box or anything -- just the cable line going into the house.  I'm guessing that if more channels were _going_ to come in at all on my tuner card, they'd already be coming in.  :-)  But I could be wrong.

>From reading other posts and following a few other forums, it looks like the analog part is still not supported by the 2.6.24 kernel.  But if these other channels are available on the digital side, that'd be cool.  My tuning, thus far, has only been on QAM256.  ATSC (antenna, right?) didn't come in at all.  I haven't tried HRC or the others. Just us-Cable-Standard-center-frequencies-QAM256, which found about 350 signals, of which only about 10 were actual working channels.

Is it possible to have more channels come in?  Should I plug in my Comcast box and use a different method to scan for channels?  (I've tried plugging in the box but that seems to kill my digital signal entirely -- I then don't get any channels)

Thanks for putting up with these really basic questions.  I apologize in advance...and greatly appreciate the help!


Markus Rechberger <mrechberger@gmail.com> wrote: On Fri, Mar 14, 2008 at 5:32 PM, r bartlett  wrote:
> I'm happily watching the several QAM channels available on my line...but can I also watch the 80 some channels that my television gets?  Is that "NTSC_M"?
>
>  Right now, if I turn on the TV I can get History, Food, Cartoon Network, etc...but on the computer it's only the basic networks and PBS.
>
>  Am I still doing something wrong?
>
>

the question is moreover what device do you have in your computer?
Also another question is are those NTSC-M Channels analogue signals
(so is it possible to connect your cable directly to an old
television, or do you have a receiver in between).
There are hybrid ATSC/QAM devices available which can also handle NTSC-M.

Markus


       
---------------------------------
Be a better friend, newshound, and know-it-all with Yahoo! Mobile.  Try it now.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
