Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:43517 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936597Ab0COTg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 15:36:27 -0400
Received: by ewy8 with SMTP id 8so1308018ewy.28
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 12:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197381003142055r271fefcbs8c5e5ea97e47c585@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
	 <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
	 <4B8F347E.2010206@gmail.com>
	 <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
	 <829197381003041139j7300bc7cg1281aff59e5a60b@mail.gmail.com>
	 <74fd948d1003041244s513dce3s69567cb9dbe31ae1@mail.gmail.com>
	 <829197381003041252m7b547e2ehced781c59c1c6edc@mail.gmail.com>
	 <74fd948d1003140806tc32b263y634405b60bd10cd0@mail.gmail.com>
	 <829197381003142055r271fefcbs8c5e5ea97e47c585@mail.gmail.com>
Date: Mon, 15 Mar 2010 19:36:21 +0000
Message-ID: <74fd948d1003151236rd1ca2d4n36c17f2344fa6e6b@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Pedro Ribeiro <pedrib@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 March 2010 03:55, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Sun, Mar 14, 2010 at 11:06 AM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>> Hi Devin,
>>
>> after some through investigation I found that your patch solves the
>> continuous interference.
>>
>> However, I have a second problem. It is also interference but appears
>> to be quite random, by which I mean it is not at a fixed interval,
>> sometimes it happens past 10 seconds, other times past 30 seconds,
>> other times 2 to 5 seconds.
>>
>> One thing is sure - it only happens when I'm actually streaming from
>> the DVB adapter. If I just plug it in, there is no interference. But
>> when I start vdr (for example) the interference starts.
>>
>> The DVB adapter and the sound card are not sharing irq's or anything
>> like that, and there is no system freeze when the interference
>> happens. I also thought it was either my docking bay or power supply,
>> but definitely it isn't.
>>
>> Any idea what can this be?
>>
>> Thank you for your help,
>> Pedro
>
> Hello Pedro,
>
> Could you describe in more detail what you mean by "interference"?  Do
> you mean that you get corrupted audio for short bursts?  Or do you
> mean the audio is dropping out for periods of time?  Can you elaborate
> on how long the problem occurs for, and how often it occurs?  For
> example, do you get corrupted audio for 1 second at a time every ten
> or fifteen seconds?


Hi Devin,

by interference I mean cracks and pops in the sound. These occur
rather randomly, and they are regular but not periodic, by which I
mean there is no defined timeframe between them. Sometimes there are 2
or 3 in a row, other times 10 seconds between them, other times 30
seconds or 1 minute.

These cracks and pops only last for a fraction of a second and they do
not interfere with the audio playing. Its like some kind of static
interference, really high pitched and loud.

> This is a USB audio device, correct?  Are both devices on the same USB
> bus?  Is there a USB hub involved?

Yes they are both USB devices. There is no USB hub involved, and they
are in different ports with different interrupts assigned to them.

> It's also possible that this is just a general latency problem - where
> the CPU becomes too busy, it does not service the sound card often
> enough and PCM data is being dropped.  Have you tried running "top"?
> What does your CPU utilization look like when you are experiencing the
> problem?

There is no jump in cpu utilization when the spikes occur. I am
running a realtime kernel and I also don't see any latency spikes when
the interferences occur.

The problem occurs with both realtime and normal kernels, on 2.6.31,
.32 and .33. Without your patch (commit
6a2071006b72bf887e38c025c60f98d2998ceacb) the problem is aggravated as
the interference is constant.

Something fishy is going on. I've spent countless hours trying to
figure out the problem it is really hard to find a pattern. This is
what I know till now:

- the first time both devices are connected to the laptop after a
fresh boot, usually there is no problem and they work nicely - the
keyword here is usually, it has happened a few times

- if i unplug and replug the dib0700 adapter, then the cracks and pops
immediately start

- stopping vdr seems to stop the cracks and pops MOST of the time -
though sometimes it also cracks without it

One thing I'm sure - without the dib0700 adapter connected to the USB
bus there is cracking at all.

This is a tough nut to crack.

Thanks for the help,
Pedro

PS: This is probably unrelated, but here is a bug report: if I boot
with the dib0700 adapter connected to the computer, the remote control
does not work. Note what dmesg says:

[   13.033653] dib0700: loaded with support for 14 different device-types
[   13.035185] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   13.036516] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   13.038045] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   13.235713] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[   13.438312] DiB0070: successfully identified
[   13.439741] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/input/input13
[   13.441301] dvb-usb: schedule remote query interval to 50 msecs.
[   13.442742] dvb-usb: Hauppauge Nova-T Stick successfully
initialized and connected.
[   13.444577] dib0700: rc submit urb failed
[   13.444579]
[   13.447573] usbcore: registered new interface driver dvb_usb_dib0700
