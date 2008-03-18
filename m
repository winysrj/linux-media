Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2I3BHj1020031
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 23:11:17 -0400
Received: from smtp108.rog.mail.re2.yahoo.com (smtp108.rog.mail.re2.yahoo.com
	[68.142.225.206])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2I3Ah7M004521
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 23:10:43 -0400
Message-ID: <47DF32A2.9000600@rogers.com>
Date: Mon, 17 Mar 2008 23:10:26 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
References: <47DC4331.7040100@rogers.com>	<1205622683.4814.13.camel@pc08.localdom.local>	<47DC6303.2040802@rogers.com>
	<47DC9B27.50601@tmr.com> <47DD5D0D.9020600@rogers.com>
	<47DDF01C.7080207@tmr.com>
In-Reply-To: <47DDF01C.7080207@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: ATI "HDTV Wonder" audio
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

Bill Davidsen wrote:
> As you note later, I'm not trying to get sound in, but out. 

In laymans terms, you ARE trying to get sound IN [to the system] ... if 
you zoom in to look at or dissect the actual process from a functional 
perspective, then yes, technically what you are trying to accomplish is 
getting the sound out of the cx88 chip and off the card ..... BUT for 
all intense purposes, this goal is so that you can get sound IN to the 
host computer system. 

This contrasts to the case of when one talks about getting sound out, as 
it almost always refers to the aspect of routing the sound outside the 
host computer system, to say a discrete stereo receiver  for 
handling/processing or whatever.

> the dongle which connects to the "looks like S_Video but isn't" socket 
> has connectors for S_Video, composite audio, and L-R channel audio

Its a mini-DIN connector ... if I recall, the ATI "Barney Purple" dongle 
is an 8pin version

DIN connectors are standardized .... though you will often see articles 
on the web in which the reviewer, upon encountering the "looks like 
S_Video but isn't", mis-reports it as being a proprietary connector. 

For some further background see: 
http://en.wikipedia.org/wiki/Mini-DIN_connector

> Since I really want this to grab output from a HD-DVR in HD, I'd like 
> to think the S_Video is the answer.

No.  You can not capture at HD resolutions with S-Video. 

The only analog interfaces that would allow you to capture at HD 
resolutions would be a HD component or VGA solution. 

There are many A/V decoder chips that are capable of capturing component 
signals.  Some of these would even be able to handle HD component.  
There are ZERO consumer  capture cards  that have component inputs. 

There are a couple of inexpensive prosumer cards with HD component input 
(eg. BM's Intensity Pro).  None of them have Linux drivers. 

There are a couple of EXPENSIVE prosumer/pro cards that feature HD 
component and/or VGA input.  None of them have open Linux drivers.  Most 
of these do, however, have proprietary Linux drivers.

> At this point I'll state (or restate) that there are traces for a 
> connector as is used by CD feeds, and as are found on several of my 
> other ATI boards 

Yes, the traditional internal loopback cable for getting an analog 
signal off the card.

Some boards offer/"are_wired" to send an analog signal off the card via 
an "external to the innards of the host system" approach whereby you'd 
run a mini-stereo connector from the back riser of the tv card and plug 
it into the mini-stereo input jack on the riser of your sound card

Some boards offer both ways -- an internal header for a loopback cable 
and an audio out on the riser.

> I suppose I could populate the board and run a cable .... AFAIK there 
> is everything except the actual socket on the card. There certainly 
> are traces for the installation of the connector, 

I rather imagine that it would indeed work ... can't see any reason why 
it would be inert...its actually rather bizarre that ATI did not include 
the header for a loopback cable ... as, as I alluded to earlier, this is 
pretty much defacto way.

> although that would involve multiple A<->D conversions. 

yes, having done the ADC once, it would be nice to keep things in the 
digital domain .... and (strictly from an operational analysis) 
following the analog route is rather an inefficient  pathway ... 
nonetheless, the analog way works well, is the defacto method, and can 
be less troublesome (particulary under Linux)

> (all low def).

I'm commenting on this point because, having browsed through your reply 
it is clear that you have formed some common misconceptions  ... one of 
which would appear to include that you are under the impression that a 
run of the mill hybrid digital/analog receiver card should be able to 
perform analog captures at HD resolutions ... this is NOT the case ... 
much of the confusion surrounds the misuse of the word "capture", 
especially when it is used in regards to such cards like the HDTV Wonder 
in a fashion such as calling them "HD capture card" 

>> if the pathway for the broadcast audio is NOT hardwired on these 
>> cards, then theoretically, it boils down to a case of the driver 
>> defining which route to take.
> Given the lack of analog output connections, I hope that's the case. 
> As noted it works with Windows.

You missed some points here:

(1) the context of my comment here was in regards to :  "in the case of 
cards using TUV1236D & saa7135"  .... this does not include your card

For your card, the HDTV Wonder  (and others like it that are TUV1236D & 
cx88 based card ... though, offhand, I don't believe there are any 
others using this chip combination), and as noted in the sidebar 
discussion of my last message, the route for the TV-in audio for cards 
is fixed/hardwired -- recall: cx88 lacks baseband audio handling 
capabilities

(2) the lack of analog output connections on the HDTV Wonder is 
irrelevant ... in neither way is one aspect reflective of the other  
i.e. that the TV-in audio pathway to the cx88 is hardwired has no 
bearing on whether the card will feature analog output connections  
..and vice versa, the lack of analog output connections is not 
indicative of how the TV-in audio pathway to the cx88 is wired

The only thing that the lack of analog output connections on the HDTV 
Wonder points towards is that ATI made a rather bizarre decision .... 
Did they not populate the trace's termination point on the surface of 
the card with a plastic header and a couple of pins because it saved 
them $0.0002 in production costs per card?  did they not do it cause 
they thought it would look uncool or ruin the card's aesthetics ?  did 
someone just simply overlook this minor detail of including a header 
before they sent the final plans off to their Taiwanese manufacturing 
partners?  .... your guess is as good as mine.

3) Windows is doing audio dma ... its using the digital audio out 
pathway  ... but your note that it works in Windows isn't applicable to 
the context of the  sidebar discussion here ... though it is, of course, 
an applicable comment to the other discussion --- just not the side bar  
/ diversionary topic ;)


> I really appreciate the time you took

Thanks -- it truly is nice to read that.

>> b) the board has to support it .... not all cx88 boards support it  
>> ... if a cx88 card is going to support digital audio (i.e. audio 
>> dma), then you will see 1741:8801 or 1741:8811 with "lspci -n" ... if 
>> absent, cx88-alsa will not work with these cards.
> I don't see any such thing.

Sorry, my mistake ... the pci id for Conexant is 14f1, and their cx88 
chips' ID, of course, are given by the 88xx   .... When Ricardo first 
posted a note about cx88-alsa a couple of years ago, he had incorrectly 
used "1741" in his examples, and I just blindly related the same 
yesterday from my notes I had jotted down from Ricardo's message .... 
interestingly, I had never caught that mistake before ... though I have 
related the same to others in the past too --- hopefully I didn't 
confuse them too much :P

> I doubt attachments are allowed, but I'll just put "lspci -n" at the 
> end of this post.

Yep, attachments won't work.... you'd have to copy the output inline, or 
use a service like pastebin or whatever and then provide a link

In any regard, from you next post, I do notice that 14f1:8801 is indeed 
present from your lspci -n output

> success, this actually does get sound and picture. 

And that proof conclusively solves the question as to why it wasn't 
working!  Good to hear that you've got that sorted out now.  In 
hindsight, I probably should have picked up on this quicker.  Oh well, 
hopefully those following this thread are richer for the experience.

> Some success ...However, the capture from the card is small, 384x288, 
> regardless of settings. Clearly not the HD I'm trying to get.

As mentioned above, you're not going to get HD through a capture of an 
analog signal.

As a note, the whole point of this test was just to make sure that audio 
dma was working properly -- and evidently it is.  For your other concern 
here, you will have to adjust capture parameters accordingly if you want 
a larger window ... but do bear in mind that you will be limited to a 
capture resolution of 720x480 with an analog source with such a card.

> Those parameters don't really work with mencoder, so I can't record 
> anything under any conditions... it "records" and I get a black screen 
> silent movie. I couldn't get ffmpeg to record either, or even try.

I imagine that you just haven't set the mencoder or ffmpeg cmdline 
arguments quite right.


> After about two years of "try, then wait for the next better drivers 
> or kernel fix," I'm about ready to admit that Linux just can't do the 
> job, and the more I search for answers the more I find zero people who 
> say they have gotten *any* currently available consumer priced 
> hardware to do HD capture, and the more people I find on lists and 
> websites and IRC asking how to do this and getting no answer. After 
> two years the driver still doesn't work usefully, and by now I can't 
> buy more cards new, and I should start over by buying a new card if 
> there was a working "over" to start.

Your disappointment is based upon faulty expectations.

Here's the bottom line -- Overall, you've got a few things confused 
about these devices and how they work. ... its really easy to arrive 
such misconceptions too, especially given that the new user is typically 
going to be exposed to this stuff from the likes of internet forums etc, 
which unfortunately tend not to be the most precise of resources, as 
they, instead, tend to be filled with posts that gloss over details, 
fail to recognize nuances, and make liberal use of misnomers....its 
99.9% non-intentional, but nonetheless, it can lead the unaware astray

In any regard, how you arrived at or formulated these misconceptions, or 
from where or when they came is unimportant --- Just throw them out, and 
start afresh.

Also take comfort in the fact that the situation under Linux is little 
different from that of a Windows perspective.   If you are interested, 
you can read through this recent thread about "HD capture solutions" 
under Linux.  You should also read that Doom9 thread to which I linked, 
as it touches upon the very few able solutions that can be used under 
Windows -- which are not easily available, not fool proof, and are 
subject to a wide range of technical considerations and constraints.

Got to run. Cheers.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
