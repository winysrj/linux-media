Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:51045
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbZKZGYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 01:24:00 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20091126054938.GH23244@core.coreip.homeip.net>
Date: Thu, 26 Nov 2009 01:23:50 -0500
Cc: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6619F77F-446F-47ED-B9F5-6CFC00E3EA49@wilsonet.com>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <20091126054938.GH23244@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 26, 2009, at 12:49 AM, Dmitry Torokhov wrote:

> On Mon, Nov 23, 2009 at 07:53:57PM -0500, Andy Walls wrote:
>> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
>>> Czesc Krzysztof,
>>> 
>>> on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
>>> [...]
>>>> I think we shouldn't at this time worry about IR transmitters.
>>> 
>>> Sorry, but I have to disagree strongly.
>>> Any interface without transmitter support would be absolutely unacceptable  
>>> for many LIRC users, including myself.
>> 
>> I agree with Christoph.  
>> 
>> Is it that the input subsystem is better developed and seen as a
>> leverage point for development and thus an "easier" place to get results
>> earlier?  If so, then one should definitely deal with transmitters early
>> in the design, as that is where the most unknowns lie.
>> 
>> With the end of analog TV, people will have STBs feeding analog only
>> video cards.  Being able to change the channel on the STB with an IR
>> transmitter controlled by applications like MythTV is essential.
>> 
>> 
>> And on some different notes:
>> 
>> I generally don't understand the LIRC aversion I perceive in this thread
>> (maybe I just have a skewed perception).  Aside for a video card's
>> default remote setup, the suggestions so far don't strike me as any
>> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
>> already works for both transmit and receive and has existing support in
>> applications such as MythTV and mplayer.
> 
> Is it that LIRC supports MythTV and mplayer or MythTV and mplayer are
> forced to support lirc because the remores are not available through
> other means? I believe it is the latter and applications writers would
> be happy to reduce number of ways they get button data.

Well, when mythtv was started, I don't know that there were many input layer remotes around... lirc was definitely around though. serial receivers and transmitters, both supported by lirc_serial, were the most frequently used devices outside of plain old keyboards. The lirc support in mythtv actually relies on mapping remote button names as defined in lircd.conf to keyboard key strokes. As mentioned elsewhere in this beast of a thread, mythtv doesn't currently support things like KEY_PLAY, KEY_VOLUMEUP, KEY_CHANNELUP, etc. just yet, but I intend on fixing that...

> I don't think there is LIRC aversion per se. We are just trying to
> decide whether multiple interfaces for the same data is needed. And
> I don't think that we will completely reject userspace components. Just
> as input subsystem allows for userspace drivers I do not think why we
> can't have the same for the LIRC. But I do think that the primary
> interface for regular userspace consumers (read mplayer and MythTV and
> the likes) should be input event interface (EV_KEY/KEY_*).

Works for me.


-- 
Jarod Wilson
jarod@wilsonet.com



