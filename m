Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KoVuK-0007m1-Ur
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 06:16:54 +0200
Received: by fk-out-0910.google.com with SMTP id f40so833972fka.1
	for <linux-dvb@linuxtv.org>; Fri, 10 Oct 2008 21:16:45 -0700 (PDT)
Message-ID: <d9def9db0810102116y20565255qd89ecc02538b43df@mail.gmail.com>
Date: Sat, 11 Oct 2008 06:16:45 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Chris Russell" <v4l@therussellhome.us>
In-Reply-To: <20081010203056.190ab2ce@arwen.therussellhome.us>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081009221330.3e355773@arwen.therussellhome.us>
	<d9def9db0810091919x2aa763bey15e39e74508763e9@mail.gmail.com>
	<20081010185825.37790e23@arwen.therussellhome.us>
	<d9def9db0810101606w46265c2bs1e81f7dfd2751039@mail.gmail.com>
	<20081010203056.190ab2ce@arwen.therussellhome.us>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx - analog tv audio on kworld 305U
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

On Sat, Oct 11, 2008 at 2:30 AM, Chris Russell <v4l@therussellhome.us> wrote:
> On Sat, 11 Oct 2008 01:06:01 +0200
> "Markus Rechberger" <mrechberger@gmail.com> wrote:
>
>> On Sat, Oct 11, 2008 at 12:58 AM, Chris Russell <v4l@therussellhome.us> wrote:
>> > On Fri, 10 Oct 2008 04:19:31 +0200
>> > "Markus Rechberger" <mrechberger@gmail.com> wrote:
>> >
>> >> On Fri, Oct 10, 2008 at 4:13 AM, Chris Russell <v4l@therussellhome.us> wrote:
>> >> >        I have a KWorld DVB-T 305U on Gentoo using the v4l-dvb-hg
>> >> > package (live development version of v4l&dvb-driver for Kernel 2.6)
>> >> > that I updated today (03Oct08).
>> >> >
>> >> >        The analog TV looks great but I cannot get the sound to work.
>> >> > I have tried just about everything I could find searching including:
>> >> > $ arecord -D hw:1 -f dat | aplay -f dat
>> >> >        and
>> >> > $ mplayer tv:// -tv driver=v4l2:device=/dev/video0:chanlist=us-cable:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=NTSC
>> >> >        and
>> >> > $ v4lctl volume mute off; v4lctl volume 31
>> >> >        and
>> >> > even attempting a manual cat from /dev/audio1 to /dev/audio
>> >> >
>> >> > So what am I missing or is audio for the 305U not working yet?
>> >> >
>> >>
>> >> Hi,
>> >>
>> >> you need the em28xx-new code from mcentral.de in order to get audio
>> >> work with it, audio for it is still in progress but it should work
>> >> fine as long as you have attached one device only.
>> >>
>> >> Markus
>> >
>> > Thanks for the reply.  Unfortunately, I still end up with the same
>> > result.  I un-installed v4l-dvb-hg, added back v4l support in my kernel
>> > (2.6.26) and pulled down the latest em28xx-new driver (based on the
>> > sunshine overlay which pulls from
>> > http://mcentral.de/hg/~mrec/em28xx-new/).  Again, tv works but audio
>> > does not.  Did I miss something?
>> >
>>
>> I think you have to look at em28xx-audioep.ko for this device.
>>
>> Markus
>>
>
> I loaded the em28xx-audioep module with no change.  Then I loaded the
> em28xx-audio module and again no change.  Anything else I should try?
>

what does arecord -l show up?

I know I have to push some patches upstream to the tv applications
(not kernel level)...
there's still tvtime from mcentral.de available which should
autodetect the correct audio device
if you have one em28xx based device plugged in...

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
