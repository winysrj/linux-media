Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78]:30615 "HELO
	smtp100.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750747AbZAYWca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 17:32:30 -0500
Message-ID: <497CE87A.3090605@rogers.com>
Date: Sun, 25 Jan 2009 17:32:26 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "A. F. Cano" <afc@shibaya.lonestar.org>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
References: <20090123015815.GA22113@shibaya.lonestar.org> <497CB355.3030408@rogers.com> <20090125214637.GA11948@shibaya.lonestar.org>
In-Reply-To: <20090125214637.GA11948@shibaya.lonestar.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A. F. Cano wrote:
> Yes.  The RF input is hooked up to an 11ft Winegard roof antenna, mounted on
> a stand behind me, properly oriented according to antennaweb.com for the
> local stations, and with a UHF pre-amp for good measure.  It is inside, but
> a foot below the reasonably high ceiling, so it doesn't interfere with moving
> around.  With this setup I have succeeded in receiving barely visible
> analog channels when the Creator is set up as a v4l device using /dev/video0.
> Yes, the reception sucks, but I want to make sure that it is not something
> more fundamental before I go to the trouble of mounting the antenna on the
> roof.
>   

Okay. One suggestion I have here is taking the pre-amp out of the chain
right now, and just test with as basic a setup as possible.

> I'm not sure how to change the cable vs. ota setting.  Doesn't the digital
> tuner determine what it is plugged into?  

Sorry, what I was getting at was the case of user error where one might
be trying to use 8VSB for the scanning on a digital cable connection, as
opposed to using the correct modulation scheme (QAM256). So, for
example, using scan in conjunction with
"us-ATSC-center-frequencies-8VSB" as opposed to
"us-Cable-Standard-center-frequencies-QAM256". Had that been the case,
it could explain the results you observed with scan. However, as you
confirmed above, that was not the case.

In regards to the determination of what is plugged in -- no, the tuner
is a dumb component. It only does what its told. In other words,
whatever piece of software you are trying to drive it by has to state
that it wants the device to use cable or OTA; as precisely illustrated
by the example with the scan utility.

> As far as mythtv, it thinks the
> attached device is a DVB/DTV receiver.  

I'd step back from testing with Myth right now -- it adds to much of
extra layer of complexity and sources for further error. In terms of
just testing to make sure that the device is working correctly, just
stick with the basic apps for the time being (scan, azap, mplayer,
femon....)

> Kaffeine has been told to use the
> us ATSC frequencies, with the results I pointed out earlier. 
>   
I haven't taken the opportunity to ever use Kaffeine for scanning OTA
just yet, however, I do note that it produces similar results for me, as
to what you observed, when I scan on digital cable using QAM256. In my
case, it repeatedly borks at 61%. I spoke with Mkrufky this morning
about Kaffeine's ATSC scanning abilities and he described it as being
less then favourable....this was actually a surprise to me, as I thought
that OTA scanning was fine. I know Devin added this support so perhaps
he could comment upon the capabilities. I also know that Devin does not
have cable, so I am not surprised to see, in my case, scans of digital
cable failing.

Reviewing your prior message, I'd suspect that dvbtune just doesn't have
support for ATSC. As you note, the other stuff is for analog.

The fact that you have the device node created and the populated by the
character devices, along with the femon result is encouraging.
Similarly, that scan is detecting something on several frequencies (just
not enough to capture any info for it) is also encouraging. I suspect
that it comes down to a case of the antenna/cable configuration ... as
noted before, take the amp out of the chain and retry ... also, if
possible, can you obtain a signal under Windows?


