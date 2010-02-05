Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34288 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0BEMTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2010 07:19:15 -0500
Received: by fxm20 with SMTP id 20so3734432fxm.1
        for <linux-media@vger.kernel.org>; Fri, 05 Feb 2010 04:19:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265369987.3649.38.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <1265369987.3649.38.camel@brian.bconsult.de>
Date: Fri, 5 Feb 2010 13:19:13 +0100
Message-ID: <846899811002050419r7bdc4632rae4cfbd7abcc93f3@mail.gmail.com>
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from same
	demux (Re: Videotext application crashes the kernel due to DVB-demux patch)
From: HoP <jpetrous@gmail.com>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chicken

>
> Furthermore: If it is technically possible to send and receive, demux
> and multiplex, play and record complete contents of a transponder (i. e.
> multiple TS streams) by using dvbstream or mumudvb (-> 8192 command line
> parameter), then I myself do not see the necessity to extend the
> capabilities of one physical device dvr0 or demux0 into a multiplicity
> of devices dvr0 or demux0.
> The what and especially the why will remain Andreas Oberritters' secret.

I can only say my 2 words regarding Andreas' patch:

At least one big DVB application is using it - enigma (originally
inside tuxbox project, later enhanced by Dream Multimedia
for theirs well-known linux based set-top-boxes Dreambox).
Those boxes are selling worlwide, so userbase is wide enough
(note: I'm not in any way connected with Dream Multimedia,
so it is only my personal feeling and/or investigation).

Of course using full TS and remuxing only in user land
is not possible way for embedded application. And if you count
that there can be more then one TS input, things are getting even worst.

And as Andy wrote:
>> But sending multiple PIDs out in a TS to the open demux0 device instance
>> is just an awkward way to essentially dynamically create a dvrN device
>> associated with filter(s) set on an open demux0 instance.
>>
>> It would be better, in my opinion, to figure out a way to properly
>> create and/or associate a dvrN device node with a collection of demuxN
>> filters.
>>
>> Maybe just allow creation of a logical demux1 device and dvr1 device and
>> the use the DVB API calls as is on the new logical devices.
>>
>> I'm not a DVB apps programmer, so I don't know all the userspace needs
>> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
>> ioctl()s.
>>
>>

Well, it is also possible way. But it expands
dvrX from usuall dvr0 to something like dvr0 ... dvr31 or so.

We definitelly need such feature.

I, personally, like DMX_OUT_TSDEMUX_TAP approach.

Rgds

/Honza
