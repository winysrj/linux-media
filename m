Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <51029ae90809290323i29693ba2xd5eb52cbc96af069@mail.gmail.com>
Date: Mon, 29 Sep 2008 12:23:31 +0200
From: "yoshi watanabe" <yoshi314@gmail.com>
To: "Anders Semb Hermansen" <anders@ginandtonic.no>
In-Reply-To: <48E0A05A.7080203@ginandtonic.no>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080929010151.111f31a2@rainbird>
	<48E0A05A.7080203@ginandtonic.no>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx88-alsa audio quality?
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
List-ID: <video4linux-list@redhat.com>

i have similar problem with cx88-alsa on hvr-1300 card.

i've been using it to connect playstation2 console to my pc via a
cable with both s-video and composite connectors.

while the video is in good quality,  the sound sounds metallic and
ofter with a very strong reverb. most of the time it's just random
noise.

sometimes it seems to pick up when there is more movement in the
video. when the picture gets still - the noise nearly goes away.

so far i have not found a solution to my problem (i've already asked
on this mailing list for help few months ago, maybe you'll find some
clues that will help you) , other than routing audio to the soundcard
via additional cables, and not taking it though the capture card.
changing sampling rates helps a bit.

hardware mpeg2 capture has perfect audio, however.

i suspected that my pc might be creating some sort of interference.
but that doesn't explain why mpeg2 capture is unaffected by it.

oh, and i cannot find any channels on analog tv. i hope that at least
radio will work (never tried it).

On 9/29/08, Anders Semb Hermansen <anders@ginandtonic.no> wrote:
> Vanessa Ezekowitz wrote:
>> Analog TV on all channels gives clean but very tinny audio, as though
>  > the sample rate were really low (~8kHz).
>
> I use a cx88 card (HVR-4000) with Analog TV (PAL). I needed to set audio
> to 48000Hz to get sound which is good. I use mythtv.
>
> English is not my native language so I don't know how to describe the sound.
>
>
> Anders
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
