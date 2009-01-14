Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp124.rog.mail.re2.yahoo.com ([206.190.53.29]:31773 "HELO
	smtp124.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752103AbZANE1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 23:27:34 -0500
Message-ID: <496D69A6.1050108@rogers.com>
Date: Tue, 13 Jan 2009 23:27:18 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "A. F. Cano" <afc@shibaya.lonestar.org>
CC: linux-dvb@linuxtv.org, Linux-media <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] OnAir creator seems to be recognized,	but what device
 is what?
References: <20090112035021.GA13897@shibaya.lonestar.org>
In-Reply-To: <20090112035021.GA13897@shibaya.lonestar.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A. F. Cano wrote:
> Dvbusb2 seems to recognize the device ok.
> In fact it seems to create
>
> /dev/dvb/adapter0/demux0
> /dev/dvb/adapter0/dvr0
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/net0
>
> And I also see /dev/video0
>
> But what do those devices represent?  Is /dev/video0 the analog tuner?
> is /dev/dvb/adapter0/dvr0 the digital tuner?  What are the others?
>   

When a driver module loads, the device manager udev will create device
nodes on /dev.

For dvb devices you get the character devices under /dev/dvb/adapterN
(where N = 0 to whatever). The character devices for each adapter N
are enumerated in form of M=0 to whatever. For example:
/dev/dvb/adapter0/frontend0 .... if the same device had a second
frontend, that character device would be enumerated by
/dev/dvb/adapter0/frontend1 ... if you had another dvb adapter in the
system, then you would see /dev/dvb/adapter1/frontend0 and so forth.

* The frontend device controls the tuner and demodulator.
* The demux controls the filters for processing the transport stream (TS).
* the dvr is a logical device that is associated with the demux
character device ... it delivers up the TS for either:
(1) immediate playback --- in which case it has to be decoded either:
a) on the device itself [its rare for PC devices to have hardware
decoding, but not so for STB] or
b) downstream by the system [the usual route for PC devices -- i.e.
software decoding via the host CPU, and possibly assisted by the GPU) ]
or
(2) saving to disk for later playback.
* the net character device controls IP-over-DVB

Similarly, with video capture (or, if you prefer, V4L) devices, you get
the /dev/video device node and the videoN character devices.

For more info, have a look at the DVB and V4L APIs.

> I have been trying to configure mythtv but have no idea what to tell it
> about this device.  The mythtv docs say that if you  have a card with 2
> tuners, define it as a DVB.  But, mythtv-setup identifies it correcly
> (by name) as an analog card /dev/video0, if I set it up as a DVB it claims
> it is a DVICO or Air2PC or...  It does not seem to know about the /dev/dvb
> devices.  Do I need to configure the OnAir Creator as 1 or 2 device 
>
> ... 
>
> I have posted the higher level questions to the mythtv mailing list, but
>
> no answers yet.  Any hints would be welcome.
>   

Sorry, no input on the myth specific questions, though surely someone
else might be able to.

> Can someone tell me a quick and easy way to test the device? maybe with
> mplayer?  I have an analog camera connected to the composite input, so
> even if I don't get any channels with the rabbit ears and loop antenna,
> that should work as a test.
See the wiki -- in particular, in the User Section, see the testing your
DVB device article. Also see the MPlayer article.


