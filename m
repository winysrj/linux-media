Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:46502
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZKZRJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 12:09:58 -0500
Message-ID: <4B0EB79B.5090406@wilsonet.com>
Date: Thu, 26 Nov 2009 12:15:07 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <20091126054938.GH23244@core.coreip.homeip.net> <6619F77F-446F-47ED-B9F5-6CFC00E3EA49@wilsonet.com> <4B0E46E6.4030006@redhat.com>
In-Reply-To: <4B0E46E6.4030006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2009 04:14 AM, Gerd Hoffmann wrote:
> On 11/26/09 07:23, Jarod Wilson wrote:
>> Well, when mythtv was started, I don't know that there were many
>> input layer remotes around... lirc was definitely around though.
>
> lirc predates the input layer IR drivers by years, maybe even the input
> layer itself.

That was my guess, but I didn't have a timeline in front of me. :)

> The main reason for the input layer IR drivers appearing was lirc not
> being mainline. A in-kernel driver (bttv in that case) which depends on
> a out-of-tree subsystem for IR support was simply a pain in the ass for
> both maintainer (/me back then) and users.
>
> At least for IR hardware which allows access to the raw samples it
> certainly makes sense to support lirc, additional to the current (or
> improved) input layer support.

I'm liking the idea of a hybrid approach, where IR devices can support 
both lirc and input device interfaces. I think its the most 
regression-proof for end-users, if done correctly, which is one of my 
biggest concerns.

>> The lirc support in mythtv actually relies on mapping remote button
>> names as defined in lircd.conf to keyboard key strokes. As mentioned
>> elsewhere in this beast of a thread, mythtv doesn't currently support
>> things like KEY_PLAY, KEY_VOLUMEUP, KEY_CHANNELUP, etc. just yet, but
>> I intend on fixing that...
>
> lircd can handle the input layer as input as well, so you actually can
> remap things via lircd even for pure input layer drivers. mythtv
> handling KEY_VOLUMEUP directly would be more elegant though.

Yeah, no, I know lircd can attach to an input device. But even if you do 
that, you have to have a mapping that converts KEY_VOLUMEUP as captured 
by lircd into (iirc) right-bracket (]) for mythtv to actually consume 
it. Directly handling definitely needs to be added to mythtv.

-- 
Jarod Wilson
jarod@wilsonet.com
