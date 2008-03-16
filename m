Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GHldgi030836
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:47:39 -0400
Received: from smtp107.rog.mail.re2.yahoo.com (smtp107.rog.mail.re2.yahoo.com
	[68.142.225.205])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2GHl5mn024631
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:47:05 -0400
Message-ID: <47DD5D0D.9020600@rogers.com>
Date: Sun, 16 Mar 2008 13:46:53 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
References: <47DC4331.7040100@rogers.com>	<1205622683.4814.13.camel@pc08.localdom.local>
	<47DC6303.2040802@rogers.com> <47DC9B27.50601@tmr.com>
In-Reply-To: <47DC9B27.50601@tmr.com>
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
> I'm not sure what you mean by external audio

An external analog audio source that you input to the card (i.e. such as 
from a DVD player, VCR, STB, camcorder etc) .... usually used in 
conjunction with the external analog video inputs (i.e. s-video or 
composite) ..... i.e. the A/V inputs .... such input signals must be 
digitized (ADC) ... in the case of the HDTV Wonder, external analog 
video signals input to the card are handled by cx88, whereas with audio, 
the ak5355, which in turn passes the then digitized audio stream to the 
cx88.

The only other audio source for the card is from the tuner .... in the 
case of digital, the card has nothing to do with the audio itself, as 
the audio stream is embedded within the transport stream received by the 
card and which is shipped downstream for processing ... in the case of 
analog, the related sound portion of the signal is usually referred to 
as either TV- or broadcast audio. With broadcast audio, unlike in the 
case of digital, the receiver card/device has a key role -- first, the 
audio portion has to be demodulated properly into L and R channel 
baseband signals and then digitized.

[ Big sidebar / side diversion / optional  discussion starts: ]

Hermann picked up on something here, and to which I've just clued into 
again as well.  Recall that Hermann had wrote: "wondering, why has the 
TUV1236D the TDA9887_PRESENT on the saa7134 cards, but not on this one?"


- on your card (HDTV Wonder) is a a tin can receiver ( 
http://www.linuxtv.org/wiki/index.php/Philips_TUV1236D ), in which is 
embedded a TDA9887 analog IF demodulator  .... in case what is meant by 
"IF" is not clear see: 
http://www.linuxtv.org/wiki/index.php/Demodulator  and  
http://www.linuxtv.org/wiki/index.php/Frontend  (this second link is 
specific to digital, but the concepts conveyed are similar and should 
help reinforce with the understanding).

-  now, returning to the TDA9887  -- it has both V-IF (video) and S-IF 
(sound) demodulation capabilities .... from memory, I believe that it 
can handle all major broadcast audio standards (BTSC, NICAM...) 
associated with the various types of analog TV standards (NTSC, PAL, 
SECAM....)

So, at first glance, one might expect that the signal pathway is:

(i)  RF signal --> tuner IC --> IF signal --> TDA9887

But this is not the case of cards using TUV1236D & cx88 .... that's 
because the signal that would be outputted from the TDA9887 would be a 
baseband analog signal and, as alluded to earlier, the cx88 doesn't have 
facilities for handling such signals ... (the allusion was in respect to 
the inability to handle external audio sources ... specifically, such 
input sources are themselves in the form of baseband audio ... this is 
why we need the 3rd party onboard ADC (the AK5355) which in turn routes 
the digitized audio stream to the cx88 via an i2c interface ..... so, in 
the case of TV-in/broadcast audio, if the card were to follow the 
pathway steps above, it would then have to route the baseband audio to 
the AK5355 first ... and that gets messy in terms traces on the PCB etc.

The key point here is that the cx88 can perform TV-in/broadcast audio 
demodulation too (i.e. demodulation of S-IF), so, a much simpler pathway 
is given by:

(ii) RF signal --> tuner IC --> IF signal --> cx88 for S-IF demodulation 
and then ADC


On the other hand, in the case of cards using TUV1236D & saa7135, things 
aren't as limited, as the the saa7135 is capable of both handling 
baseband audio sources AND demodulation of S-IF.  So, it would seem that 
with these cards there are, theoretically,  two different, but 
legitimate, pathway choices for TV-in/broadcast audio:

(i)  RF signal --> tuner IC --> IF signal --> TDA9887  --> baseband 
signal --> saa7135 for ADC

or

(ii)  RF signal --> tuner IC --> IF signal --> baseband audio -->  
saa7135 for S-IF demodulation and then ADC

Now is the actual pathway hardwired for these cards, or can we actually 
control that aspect via the drivers ??  I don't know.  Earlier, at the 
beginning of this diversionary discussion, I said that I just clued into 
this point again because I had forgotten that I had once pondered this 
question before, but Hermann's astuteness reminded me of this  .... I 
just don't remember in what thread, or if it was on the #IRC channel,  
that I placed my enquiry about the pathway being used by TUV1236D & 
saa7135  based cards

If I'm not mistaken, I think I did so while I was investigating the 
sound sampling (ADC) capabilities with the saa7135 ... currently, the 
saa7135 Linux driver limits sampling of broadcast audio to 32KHz (the 
data sheet indicates that 48KHz is also possible, but offhand I can't 
recall the exact reason why this is not feasible; though it has been 
discussed on a number of occasions in the past).  On the other hand, the 
saa7135 should be able to sample (i.e. perform ADC on) baseband audio 
sources at either 32, 44.1, or 48KHz ... and, to the best of my 
knowledge, this later case of choice does indeed work as expected.

I'll have to think about this, and try to find that thread to which I 
posted, as I don't recall receiving a satisfactory answer ... in any 
regard, if it is not clear to what I driving at, here is the implication:

if the pathway for the broadcast audio is NOT hardwired on these cards, 
then theoretically, it boils down to a case of the driver defining which 
route to take. 

If the driver is written to use scenario (ii), which I believe is the 
case, then because of the limitations of the saa7135's S-IF demodulation 
capabilities, the end user is stuck with having to "capture"  analog 
TV-audio at 32KHz ... for those of you not familiar with the TV-audio 
capturing quality of this chip, lets just say that its less then stellar 
(i.e. tinny sounding; prone to clipping; prone to crackling and metallic 
"zing" like sounds ... turning the audio input level in the mixer down 
alleviates some of those, but they are still present). 

If the driver is written to use scenario (i), then theoretically, it 
should provide some flexibility for the end user -- i.e. choice of 
either 32, 44.1, or 48KHz sampling rates  ... the hope, in this point, 
is that one of the other sampling rates would provide better 
results/quality then as obtainable under the current situation (i.e. 
limited to 32KHz and less then stellar quality)

[ :Big sidebar / side diversion / optional  discussion ends ]


> when the card was tried in a Windows system it had sound, so there is 
> some way to get the audio "external" of the card and into the computer. 

The above description (immediately above the long-winded optional 
discussion) should bring some clarity as to what I had meant by external 
audio .... unfortunately, I see that I also used "external" again in my 
earlier message's description ... though this second case was meant in a 
different context, I do see how this could have contributed to some 
confusion. 

In any regard, lets address this second point:   "getting the audio 
external of the card"

After the cx88 has processed the broadcast audio, it has two choices of 
what to do with the audio at that point:

(i) send it through the chip's internal DAC and then route it directly 
off the card to a sound card for processing ... you'd do this via a 
loopback cable that you'd attach directly between the tv-card and sound 
card, or via an external cable between the tv-card (on the back of the 
card's riser) and an input jack on the soundcard. 

or

(ii) keep the now digital signal in the digital domain by having the 
cx88 packetize the audio bitstream and send it across the PCI bus for 
processing downstream .... attaching a label to a process, what we're 
talking about here is referred to as audio DMA.


Intuitively, route (i) sounds a little retarded -- after all, the card 
has just performed ADC on the audio, so why in the hell would you want 
to do DAC and send it off to the soundcard for another round of ADC?  
But if you said that route (i) is the norm as opposed to the exception, 
you'd also be right.

In any regard, route (i) isn't even an option for the HDTV wonder as, 
like I mentioned in the earlier message:

 CityK wrote:
> the HDTV Wonder lacks any sort of audio out (via either an internal 
> loop back cable to the sound card or similarly an external out on the 
> riser).  Therefore ... you would indeed need to use cx88-alsa,

Using cx88-alsa implies that you'd be using route (ii); the audio DMA 
route.  The situation under a Windows OS is exactly the same -- a driver 
with audio DMA capabilities must be present, else you'd receive no audio.


Bill Davidsen wrote:
> As noted in my original post, I'm using cx88_alsa,

I think that is what initially lead me to believe that you were only 
talking about an external audio source, because as far as I'm aware, 
cx88-alsa works for the HDTV wonder...but there are some other points 
about using cx88-alsa which I failed to take into consideration in your 
case (which I'll address very shortly) and prematurely jumped to the 
conclusion that you were looking to get an external audio source working 
with your card.

By the time Hermann replied, and I replied back to him, I had long 
forgotten your statement about using alsa and the fact that it was it 
(that fact in itself) which had initially lead me to formulate my 
original reply as I had.  By the time I took Hermann's observations into 
consideration, I was well along in the process of turning a clean answer 
into something very opaque.

So, having played a key part in muddying the waters, I hope that this 
reply clears them up and provides a conclusive explanation of the 
broadcast audio  facilities available on your card.

> I'm using cx88_alsa  ... I loaded the cx88_alsa module with "index=1" 
> and now /proc/asound/cards shows the internal audio as card0 and the 
> cx88 as card1. But I can't get any sound OUT of the card to play, or 
> even record. ... it just doesn't work. It's not muted, the volume is 
> up, but nothing. Why they didn't populate the soundcard out on the 
> card I don't know, all the traces are there but no socket is provided.
>
> Is it likely that "pulseaudio" stuff is the problem? This is the first 
> time I've used it with video, so I'm at least suspicious, but several 
> people warned I can't just rip it out, I may have to drop back to 
> several older things.

Linux and audio DMA with the cx88:

a) the chipset on the card has to support it ... which we already know 
is true

b) the board has to support it .... not all cx88 boards support it  ... 
if a cx88 card is going to support digital audio (i.e. audio dma), then 
you will see 1741:8801 or 1741:8811 with "lspci -n" ... if absent, 
cx88-alsa will not work with these cards.

We already know your board should do audio dma (your Windows test, for 
example proves this).  So, a "lspci -n | grep 1741" should indeed spit 
out a "8801" or "8811" answer 

c) you need a driver to support it ...  cx88-alsa ... which appears to 
be loading fine for your card.

d) you need applications that support it ... Uh-oh, here's the biggie 
.... and this is where I now suspect you are running into difficulty.

Not many viewing apps under Linux  natively support audio DMA.  Mythtv 
and mplayer do.  tvtime, xawtv etc etc don't.

- With mplayer and the cx88, you will also have to specifically use 
"norm=NTSC-M" in your cmdline argument.
- Mythtv should have an option for setting up the correct sound device 
(default is /dev/dsp ... which should be your sound card, so you'll have 
to adjust this setting for your tvcard ... i.e. likely /dev/dsp2 or 
whatever)
- with tvtime, xawtv etc, you'll have to use a helper application like 
arecord or sox before audio dma will work.

I suggest you first test with mplayer to see if its working.  Try 
something "basic" like this:

mplayer -v tv:// -tv 
driver=v4l2:norm=NTSC-M:input=0:alsa:adevice=hw.1,0:forceaudio:immediatemode=0:audiorate=48000:amode=1:width=384:height=288:outfmt=yuy2:device=/dev/video0:chanlist=us-cable:channel=7

The command is all one line, so just copy and paste it into a console.  
Note: it should be pretty generic for most systems with just one tv 
card, but if any of the parameters listed above differ, then you will 
have to adjust them accordingly to your system configuration.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
