Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LIu1H-0004eL-QX
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 01:05:39 +0100
From: Andy Walls <awalls@radix.net>
To: Greg <thewatchman@gmail.com>
In-Reply-To: <c715948d0901020631rf3b24b1md411d7cad2eb40cc@mail.gmail.com>
References: <c715948d0812301528h5a4f2a57xa973099ffb33730@mail.gmail.com>
	<1230773531.3121.13.camel@palomino.walls.org>
	<c715948d0901020631rf3b24b1md411d7cad2eb40cc@mail.gmail.com>
Date: Fri, 02 Jan 2009 19:07:47 -0500
Message-Id: <1230941267.5194.12.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pcHDTV-5500 and FC10 (resend, was too big)
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

On Fri, 2009-01-02 at 08:31 -0600, Greg wrote:
> It seems like something is broken with the code with regard to
> detecting the tuner type or maybe the tuner tyes are wrong in the
> code.
> 
> I have tried specifying a tuner type in modeprob.d/options and this
> has given me limited success (options cx88xx tuner=64). I have been
> able to get the channel scan to work doing this, but so far no video
> capture. I am not sure what the correct tuner is or how I can now
> capture video to see if it is working. I have tried the watch tv
> option and catpure video on mythtv tv, but the live TV times out and
> the recorded video is just snow, so something is still not quite right
> with the setup. 
> 
> Is there a simple way to dump the digitial video from a specified
> channnel to a file and play it with mplayer or something?

Please try not to top post.

For mplayer testing use the dvb-apps scan util to create a channels.conf
file.  put it in ~/.mplayer/channels.conf, if you don't already have
one.

Then

$ mplayer dvb://WFOO-DT

or

$ mplayer dvb://WFOO-DT -vf scale=960:540

to play 1920x1080 content on a smaller monitor (like a 1280x1024).

Regards,
Andy

> Hope someone can help fix this tunner issue. (see my previous post for
> more details).
> 
> Greg
> 
> 
> 
> 
> On Wed, Dec 31, 2008 at 7:32 PM, Andy Walls <awalls@radix.net> wrote:
>         
>         On Tue, 2008-12-30 at 17:28 -0600, Greg wrote:
>         > I have been trying to get my PCHD-5500 card to work  with
>         FC10. So far
>         > I am able to get  the analog tuner portion of the card to
>         work but not
>         > the digital. Devinheitmueller was pointing me in the
>         direction to
>         > look. I am getting a crash in one of the modules, which
>         looks like it
>         > is coming from the line:
>         >
>         > div = ((frequency + t_params->iffreq) * 62500 + offset +
>         > tun->stepsize/2) / tun->stepsize;
>         >
>         >
>         > The crash is apparently being cased by a zero stepsize. This
>         crash
>         > occured when I was scanning for channels either from
>         mythtvset or
>         > Kaffeine, or a command line program that came with the card.
>         I also
>         > have  Hauppague 250 card in the system which seems to work.
>         >
>         > If I select the digital tuner from mythtv the application
>         just hangs
>         > and I get a blank screen.
>         >
>         > I tried hacking the tuner-types.mod.c file and adding the
>         following
>         > lines to it that I coppied from one of the other cards
>         (though I
>         > suspect these values are not right for this card)
>         >
>         >     [TUNER_LG_NTSC_TAPE] = { /* LGINNOTEK NTSC */
>         >                 .name   = "LG NTSC (TAPE series)",
>         >                 .params = tuner_fm1236_mk3_params,
>         >                 .count  =
>         ARRAY_SIZE(tuner_fm1236_mk3_params),
>         >                 //adding these lines copied from above so
>         that we have
>         > no-zero values
>         >                 .min = 16 * 53.00,
>         >                 .max = 16 * 803.00,
>         >                 .stepsize = 62500,
>         >
>         
>         
>         The TAPE-Hxxx series tuners are an LG rebrand of the
>         equivalent Phillips
>         tuner.  The TAPE-H091F-MK3 and TAPE-Hxxx data sheets I have
>         say this
>         about the analog ranges:
>         
>         Low :   55.25 - 157.25 MHz
>         Mid :  163.25 - 439.25 MHz
>         High:  445.25 - 801.25 MHz
>         FM:     88.00 - 108.00 MHz
>         
>         The step size is programmable: 31.25 kHz, 50.00 kHz, 62.50
>         kHz, ...
>         
>         With a control byte of 0x8e (as in the
>         tuner_fm1236_mk3_params), you're
>         programming a step size of 62.50 kHz.
>         
>         Of course this is an analog M/N system tuner with FM radio.  I
>         suspect
>         this isn't the tuner you're looking for, for Digital TV.
>         
>         Regards,
>         Andy
>         
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
