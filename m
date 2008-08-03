Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KPhiG-0007UM-RW
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 19:49:49 +0200
Received: by yw-out-2324.google.com with SMTP id 3so811328ywj.41
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 10:49:44 -0700 (PDT)
Message-ID: <5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
Date: Sun, 3 Aug 2008 10:49:43 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1217728894.5348.72.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
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

On Sat, Aug 2, 2008 at 7:01 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2008-07-29 at 19:34 -0700, Brian Steele wrote:
>
>
>> cx18-0: VIDIOC_QUERYCTRL id=0x980909, type=2, name=Mute, min/max=0/1,
>> step=1, default=0, flags=0x00000000
>> cx18-0: VIDIOC_QUERYCTRL id=0x98090a, type=2, name=Mute, min/max=0/1,
>> step=1, default=0, flags=0x00000001
>> cx18-0: VIDIOC_QUERYCTRL id=0x99096d, type=2, name=Audio Mute,
>> min/max=0/1, step=1, default=0, flags=0x00000000
>>
> IIRC, one mute is for the audio processing paths in the cx18-av-core,
> the other mute is for muting the audio in the MPEG encoder.

Looking at the code it looks like the one named "Audio Mute" is for
the MPEG encoder and the one named "Mute" is for cx18-av-core.  As you
can see there are three mutes with different ids in my output.  This
seems very odd to me.

>> I'm using v4l-dvb pulled from hg about 2 hours ago.  Does anybody have
>> any ideas what else I can do to debug this or how to fix it?
>
> First make sure that line in audio from a portable DVD player or VCR
> still works.  Just to make sure that in fact tuner audio is the only
> problem.

I plugged a camcorder into S-Video1 and successfully captured audio
when I did playback from the camcorder.  I think this confirms that
tuner audio is the only problem.

> Then with tuner video & audio, you need to try to get the system to a
> state where the audio microcontroller in the cx18-av-core actually
> detects a sound standard in the SIF audio coming from the tuner.  Try
> changing channels and see if there is any channel that gives you sound -
> or at least shows that the microcontroller has detected a sound
> standard.
>
> If that doesn't work, I look into how you can manually have the MPEG
> encoder fall back to using Tuner AF (mono) instead of Tuner SIF audio.
> Then we can make sure at least determine if the chips in the tuner are
> demodulating the sound carrier properly.

I tried about 7 different channels.  None of them showed a detected
audio standard and none of them had any sound when I did test
captures.  All my test captures have good video.

> (Also note that the first analog capture after modprobe cx18 will not
> work right: it will have no audio or choppy audio.  Every subsequent
> capture should work fine.)

Yes, I've seen this.  I continue to have no audio from the tuner after
numerous captures.

Thanks,
Brian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
