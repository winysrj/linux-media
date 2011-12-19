Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1LSLZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 06:25:06 -0500
Received: by wgbdr13 with SMTP id dr13so10531826wgb.1
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 03:25:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112191155340.23694@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<201112191105.25855.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1112191113230.23694@axis700.grange>
	<201112191120.40084.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1112191139560.23694@axis700.grange>
	<CACKLOr0Z4BnB3bHCs8BjhwpwcHBHsZA1rDNrxzDW+z3+-qSRgQ@mail.gmail.com>
	<Pine.LNX.4.64.1112191155340.23694@axis700.grange>
Date: Mon, 19 Dec 2011 12:25:04 +0100
Message-ID: <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 December 2011 11:58, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Mon, 19 Dec 2011, javier Martin wrote:
>
>> On 19 December 2011 11:41, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
>> >
>> >> Hi Guennadi,
>> >>
>> >> On Monday 19 December 2011 11:13:58 Guennadi Liakhovetski wrote:
>> >> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
>> >> > > On Monday 19 December 2011 09:09:34 Guennadi Liakhovetski wrote:
>> >> > > > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
>> >> > > > > On Friday 16 December 2011 10:50:21 Guennadi Liakhovetski wrote:
>> >> > > > > > On Fri, 16 Dec 2011, Scott Jiang wrote:
>> >> > > > > > > >> How about this implementation? I know it's not for soc, but I
>> >> > > > > > > >> post it to give my idea.
>> >> > > > > > > >> Bridge knows the layout, so it doesn't need to query the
>> >> > > > > > > >> subdevice.
>> >> > > > > > > >
>> >> > > > > > > > Where from? AFAIU, we are talking here about subdevice inputs,
>> >> > > > > > > > right? In this case about various inputs of the TV decoder. How
>> >> > > > > > > > shall the bridge driver know about that?
>> >> > > > > > >
>> >> > > > > > > I have asked this question before. Laurent reply me:
>> >> > > > > > > > >> ENUMINPUT as defined by V4L2 enumerates input connectors
>> >> > > > > > > > >> available on the board. Which inputs the board designer
>> >> > > > > > > > >> hooked up is something that only the top-level V4L driver
>> >> > > > > > > > >> will know. Subdevices do not have that information, so
>> >> > > > > > > > >> enuminputs is not applicable there.
>> >> > > > > > > > >>
>> >> > > > > > > > >> Of course, subdevices do have input pins and output pins,
>> >> > > > > > > > >> but these are assumed to be fixed. With the s_routing ops
>> >> > > > > > > > >> the top level driver selects which input and output pins
>> >> > > > > > > > >> are active. Enumeration of those inputs and outputs
>> >> > > > > > > > >> wouldn't gain you anything as far as I can tell since the
>> >> > > > > > > > >> subdevice simply does not know which inputs/outputs are
>> >> > > > > > > > >> actually hooked up. It's the top level driver that has that
>> >> > > > > > > > >> information (usually passed in through board/card info
>> >> > > > > > > > >> structures).
>> >> > > > > >
>> >> > > > > > Laurent, right, I now remember reading this discussion before. But
>> >> > > > > > I'm not sure I completely agree:-) Yes, you're right - the board
>> >> > > > > > decides which pins are routed to which connectors. And it has to
>> >> > > > > > provide this information to the driver in its platform data. But -
>> >> > > > > > I think, this information should be provided not to the bridge
>> >> > > > > > driver, but to respective subdevice drivers, because only they
>> >> > > > > > know what exactly those interfaces are good for and how to report
>> >> > > > > > them to the bridge or the user, if we decide to also export this
>> >> > > > > > information over the subdevice user-space API.
>> >> > > > > >
>> >> > > > > > So, I would say, the board has to tell the subdevice driver: yes,
>> >> > > > > > your inputs 0 and 1 are routed to external connectors. On input 1
>> >> > > > > > I've put a pullup, it is connected to connector of type X over a
>> >> > > > > > circuit Y, clocked from your output Z, if the driver needs to know
>> >> > > > > > all that. And the subdev driver will just tell the bridge only
>> >> > > > > > what that one needs to know - number of inputs and their
>> >> > > > > > capabilities.
>> >> > > > >
>> >> > > > > That sounds reasonable.
>> >> > > >
>> >> > > > Good, this would mean, we need additional subdevice operations along
>> >> > > > the lines of enum_input and enum_output, and maybe also g_input and
>> >> > > > g_output?
>> >> > >
>> >> > > What about implementing pad support in the subdevice ? Input enumeration
>> >> > > could then be performed without a subdev operation.
>> >> >
>> >> > soc-camera doesn't support pad operations yet.
>> >>
>> >> soc-camera doesn't support enum_input yet either, so you need to implement
>> >> something anyway ;-)
>> >>
>> >> You wouldn't need to call a pad operation here, you would just need to iterate
>> >> through the pads provided by the subdev.
>> >
>> > tvp5150 doesn't implement it either yet. So, I would say, it is a better
>> > solution ATM to fix this functionality independent of the pad-level API.
>>
>> I agree,
>> I cannot contribute to implement pad-level API stuff since I can't
>> test it with tvp5150.
>>
>> Would you accept a patch implementing only S_INPUT?
>
> Sorry, maybe I'm missing something, but how would it work? I mean, how can
> we accept from the user any S_INPUT request with index != 0, if we always
> return only 0 in reply to ENUM_INPUT? Ok, G_INPUT we could implement
> internally in soc-camera: return 0 by default, then remember last set
> input number per soc-camera device / subdev. But ENUM_INPUT?...

It clearly is not a complete solution but at least it allows setting
input 0 in broken drivers such as tvp5150 which have input 1 enabled
by default, while soc-camera assumes input 0 is enabled.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
