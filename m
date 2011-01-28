Return-path: <mchehab@pedra>
Received: from alpha.zimage.com ([173.51.181.2]:44950 "EHLO beta.zimage.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1A1UXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 15:23:36 -0500
Date: Fri, 28 Jan 2011 12:15:38 -0800
From: Phillip Pi <ant@zimage.com>
To: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: DM6446
Message-ID: <20110128201538.GO25038@beta.zimage.com>
References: <AANLkTindYgatAuWoVog0dnVKkhUHWO9-MaOC39oAMQgK@mail.gmail.com>
 <20110127092248.18877dx8p3qe0k0o@webmail.hebergement.com>
 <AANLkTimNr=87qc7TKwJu6c3grphfbToD2tpQcpnXHv3w@mail.gmail.com>
 <20110128094254.11965b0zcrkqshhq@webmail.hebergement.com>
 <AANLkTiniyqtmzv7UUC9AiDQYcOb1Sa+aKDbdvB0ioS=M@mail.gmail.com>
 <2dac589a6c232e004c3f29de4252b883.squirrel@sensoray.com>
 <20110128173627.GL25038@beta.zimage.com>
 <000301cbbf21$116c7e60$34457b20$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cbbf21$116c7e60$34457b20$@com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 28, 2011 at 11:25:04AM -0800, Charlie X. Liu wrote:
> 1) Is your driver for ASUS TV tuner right?

I assume it is. I had help from various people in my very long 
newsgroup/usenet forum thread in 
http://groups.google.com/group/comp.os.linux.hardware/browse_frm/thread/eced1d3cf6497abf 
... Check those out. See what we did and tried. We failed to make xawtv 
work with it. We THINK we got the drivers working based on dmesg 
results, but we don't get any video (only blue color) or audio.


> 2) tvtime ( http://tvtime.sourceforge.net/ ) may work for you better, as
> it's designed for TV tuner type of capture cards.

Wow, this one is old too. What's up with these very old programs? :( Is 
TV tuner and capture cards not popular in Linux? :(

Anyways, I downloaded tvtime v1.0.2-6.1 from apt-get, with 48 other new 
packages. I see my TV/capture card is supported according to 
http://tvtime.sourceforge.net/cards.html#cx88 ... I have never done any 
TV and video capture cards. I am mainly interested in the video 
capturing from my VCR and other video sources. I don't care for the TV 
stuff since I have HDTV tuner cards in my Windows box (had no problems 
with my ASUS TV tuner/capture card).


> 3) For V4L/V4L2 compliance test, I like Xawtv better (personally). Though
> it's old, it's mature and stable.

Thanks. :)


> -----Original Message-----
> From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Phillip Pi
> Sent: Friday, January 28, 2011 9:36 AM
> To: video4linux-list@redhat.com
> Subject: Re: DM6446
> 
> Wow, these are old. Did Xawtv project die or something? Is there an 
> updated fork or anything? I never got my old ASUS TV tuner to work 
> with it. :(
> 
> 
> On Fri, Jan 28, 2011 at 11:25:48AM -0600, charlie@sensoray.com wrote:
> > It's in:
> > 
> > http://rbytes.net/linux/xawtv-review/
> > http://linux.wareseeker.com/Multimedia/xawtv-3.95.zip/322997
> > http://nixbit.com/cat/multimedia/video/xawtv/
> > 
> > 
> > > Does any one has resources/source of XAWTV ?!
-- 
Quote of the Week: "A coconut shell full of water is a(n) sea/ocean to an ant." --Indians
  /\___/\          Phil./Ant @ http://antfarm.ma.cx (Personal Web Site)
 / /\ /\ \                 Ant's Quality Foraged Links: http://aqfl.net
| |o   o| |                 E-mail: philpi@earthlink.net/ant@zimage.com
   \ _ /              If crediting, then please kindly use Ant nickname
    ( )                                              and AQFL URL/link.
