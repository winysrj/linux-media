Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KWQS3-0005kk-2M
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 08:48:52 +0200
Date: Thu, 21 Aug 2008 23:48:15 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808211719l520f781aj9e916317edb8506e@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <40885.21920.qm@web46107.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
Reply-To: free_beer_for_all@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--- On Fri, 8/22/08, Beth <beth.null@gmail.com> wrote:

> are a lot of  channels with 0:0 at its vid and aid, I assume that if
> scan was finding channels it is doing on the correct way.

It looks as if you have a similar problem to that I see at times
with one of my cards.  On my other machine with two different
cards, I always get the correct PIDs, and so far, I have not
been able to explain my problem.

So it sounds to me that either `scan' is not working completely
correctly with our cards, or the driver for the cards is missing
something to make `scan' work better.

Or something else.


> The second, I had learned a lot, a lot about dvb, I need to learn much
> more but it is a funny way of learning.

It is the way I learn too.  I would say it is the best way, but
it is not a good way if one is trying to find a job...  :-P


> Well, and the big question, why scan didn't found the vid and aid for
> a lot of channels?

I do not know  ;-)

What you can do to try and find out why there is a problem, is
scan several times, and `diff' the results.  The questions I
have would be,
*  Do you always get 0:0 PIDs for the same channels, or, as I do,
   is it on different transponders for each scan?
*  Is it the case that you see 0:0 PIDs for all channels on a
   transponder in a scan?
*  Does `scan -v' show anything strange to stderr when there are
   problems (timeouts on PIDs 0x10 and 0x11 and such)?
*  Do you see anything else strange that is different between the
   scans?

In my case, here is what I see that is incorrect with my card:

I am scanning with a hacked `scan' that ignores NIT tables and scans
channels from a single transponder, fed by a list of all Astra 19E2
carrier frequencies.  That is, I call `scan' once for a single
frequency, then call it again for the next frequency.

When I have problems, I'm not only seeing the 0:0 PIDs for all
services on the tuned transponder, but in addition, I'm seeing
``leftovers'' of the services from the last transponder tuned.

Here's some actual output from my last scan in June:
  Scanning 10758500     v       22000   # ANALOG        QVC DE

  Scanning 10773250     h       22000
Belsat TV:10773:h:1:22000:512:650:17100
TV TRWAM:10773:h:1:22000:513:660:17101
TV Polonia:10773:h:1:22000:514:670:17102
TVP Historia:10773:h:1:22000:515:680:17103
TVP Kultura:10773:h:1:22000:516:690:17104
Radio Maryja test:10773:h:1:22000:0:661:17201

All well and good so far.  The next frequency has problems:

  Scanning 10788000     v       22000
[42cc]:10788:v:1:22000:0:0:17100
[42cd]:10788:v:1:22000:0:0:17101
[42ce]:10788:v:1:22000:0:0:17102
[42cf]:10788:v:1:22000:0:0:17103
[42d0]:10788:v:1:22000:0:0:17104
[4331]:10788:v:1:22000:0:0:17201
### SCRAMBLED!!!  #TAQUILLA 1:10788:v:1:22000:0:0:30350
### SCRAMBLED!!!  #TAQUILLA 2:10788:v:1:22000:0:0:30351
### SCRAMBLED!!!  #TAQUILLA 3:10788:v:1:22000:0:0:30352
### SCRAMBLED!!!  #TAQUILLA 4:10788:v:1:22000:0:0:30353
### SCRAMBLED!!!  #ANIMAX:10788:v:1:22000:0:0:30356
### SCRAMBLED!!!  #TAQUILLA XY:10788:v:1:22000:0:0:30357
### SCRAMBLED!!!  #CARTOON NET.:10788:v:1:22000:0:0:30358
### SCRAMBLED!!!  #BOOMERANG:10788:v:1:22000:0:0:30361
### SCRAMBLED!!!  #TAQUILLA 10:10788:v:1:22000:0:0:30362
### SCRAMBLED!!!  #SAN FERM<CD>N:10788:v:1:22000:0:0:30363

The first six services are not present on this C+Esp transponder,
but the service IDs (last field) are in fact those from the
TVPolonia transponder tuned before.

And the second problem is that all these subscription channels
are saved with 0:0 PIDs rather than the correct ones.  I am
sure these two problems are somehow related, but I don't know
how, and until now, I have not tried to investigate further.

And in my scan from Mar.2008, I don't see any problem here.
I have correct PIDs for all services on 10788.  I have problems
on other transponders instead.



> 538 channels with 0:0 at vid:aid, of 1353, I dont know if that is
> normal or if I must to re-scan.

That is not normal -- and the fact that you got 0:0 for TV Galicia
is also very wrong.  As I suggest, you should try three or four
scans, to see if you get the same errors every time.


> > Anyway, I'm not sure if the programs you use are capable of dynamically
> > determining the relevant PIDs based on the service number (30222) --
> 
> I really don't know if this is possible.

It is; if I remember correctly, there was a message posted in the
last week or three about some utility that would do this.  But it
is not so important, as usually, at Astra 19E, the PIDs do not change.


> > dvbsnoop...  One moment...
> > PID 53 is teletext;
> > the remaining 11 PIDs appear to be data that you can ignore.
> > These are 208, 222, 309, 392, 213, 253, 307, 356, 761, 888, 623.
> > They can be seen in PID 1053 (dvbsnoop -s ts -tssubdecode -if ... 1053)
> 
> At this point I am a bit lost, I must to re-read things a
> bit ;).

Better is not to.  You can ignore what I wrote above, and
re-reading what I wrote after that (and deleted when trimming
for this reply), I see that I was not clear -- you answered
what I wanted to know, that more than 1/3 of your scan results
are not correct.

Looking at the last full scan I made at 19E, on 2008-07-07, I
count 1418 digital services.  But I've hacked my very old `scan'
program so that it outputs services that may be missing from an
unhacked version -- such as programs that are in `not running'
status, or data services, or DVB-S H.264 (AVC) video streams --
I don't have a DVB-S2 card yet so I can't count those services,
so your number could be higher by 10 or so.

I'm too lazy to make a new scan today for an up-to-date count, but
it looks that you do not have the problem that I have of ``ghost''
services that increased my service count above 1600 from my card
with the 0:0 PIDs problem.



> I don't know if tomorrow I will have free time at home, but as soon as
> I can do it I am going to re-scan, re-check all, and inform you as

I would be very interested to learn your results from repeated
scans.

I probably won't be able to do anything to fix the problems, but
I'm still interested, and maybe someone with better scan-fu or
driver-fu can identify the problems.

And maybe, I can get my one card to produce 100%-useful scan
results, without having to so much as lift a finger against my
own code.  Wouldn't that be marvelous...

(The `scan' problems are the only visible problem with this card,
the dvb-usb Opera device, that I experience.  All recordings I've
made have been free of problems, other than problems that appear
to be caused by something else in the kernel)


barry bouwsma
sleep?


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
