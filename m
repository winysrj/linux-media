Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1L4dmt-0004U0-Qg
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 16:55:49 +0100
Received: from webmail.xs4all.nl (dovemail11.xs4all.nl [194.109.26.13])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id mAOFtg4h006652
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 16:55:42 +0100 (CET)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <13077.130.36.62.140.1227542142.squirrel@webmail.xs4all.nl>
Date: Mon, 24 Nov 2008 16:55:42 +0100 (CET)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
Reply-To: n.wagenaar@xs4all.nl
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

-----Original message-----
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Sent: Mon 24-11-2008 10:07
To: linux-dvb@linuxtv.org;
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API

> On 24.11.2008 08:12, Artem Makhutov wrote:
> > Hello,
> >
> > Klaus Schmidinger schrieb:
> >> The attached patch adds a capability flag that allows an application
> >> to determine whether a particular device can handle "second generation
> >> modulation" transponders. This is necessary in order for applications
> >> to be able to decide which device to use for a given channel in
> >> a multi device environment, where DVB-S and DVB-S2 devices are mixed.
> >>
> >> It is assumed that a device capable of handling "second generation
> >> modulation" can implicitly handle "first generation modulation".
> >> The flag is not named anything with DVBS2 in order to allow its
> >> use with future DVBT2 devices as well (should they ever come).
> >>
> >> Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
> >
> > Wouldn't it be better to add something like this:
> >
> > FE_CAN_8PSK
> > FE_CAN_16APSK
> > FE_CAN_32APSK
> >
> > or
> >
> > FE_CAN_DVBS2
> >
> > Instead of FE_CAN_2ND_GEN_MODULATION ? It is too generic for me.
>

I agree with Artem on this one.

> Well, it's bad enough that we have to "guess" which kind of
> delivery system it is by looking at feinfo.type. If it's FE_QPSK
> then it's DVB-S (or DVB-S2), if it's FE_OFDM then it's DVB-T etc.,

With most software I used on Windows (DVB Viewer Pro and Mediaportal) I
have to enable "DVB-S2" features on my card. Perhaps since we don't have a
FE_CAN_8PSK or an other sollution to check this, this might be the best
option you seek. Or use my very ugly patch (tm) where I check for the
string "DVBS2" in the card's deliverysystem and then set the frontendtype
to SYS_DVBS2 (which is backwards compatible with DVB-S).

> etc. The "multiproto" API had this cleaned up and introduced a
> clean way of finding out the delivery systems(!) a particular device
> can handle. Unfortunately, as we all know, this approach has been
> dismissed.

I don't know multiproto perse and I didn't check the multiproto code
within VDR in general. I just used Igor's S2API patch for VDR 1.7.0 which
only had DVB-S2. I then added the other SYS_ types and added the VUP I
wrote about earlier.

> Using some additional flags for "guessing" whether it's DVB-S2
> doesn't seem like a clean solution to me. Why not simply state
> the obvious? After all, the DVB standard for DVB-S2 speaks of
> "second generation modulation", that's why I named this flag
> that way.

With DVB-S2, I rather speak of an enhancement then of second generation.
But this is my oppinion and you can simply ignore this! ;)

> And since S2API can only handle a single delivery system
> at a time (as opposed to multiproto, where the delivery systems
> were flags, so a device could support several of them), it
> somehow made sense to me to have a flag that could later also
> be used for "second generation DVB-T" devices.
>

If I am correct, S2API will handle multiple delivery systems without any
problems. A device can handle multiple delivery systems because the
frontend (/dev/dvb/adapter[0,1,2,etc]/frontend[0,1,2,3,etc]) is the real
device(-location which) will handle the DVB delivery/transport. This can
be DVB-T, DVB-S, DVB-S2 or DVB-C (not and!). And we open a frontend
adapter of the device for tuning and that will only support one DVB
transport (we don't ask the card to tune, we ask the frontend
device-location to tune).

At least, this is the way as I understand how tuning with DVB-cards works
in general. And this is also the way how I implented the S2API patch. But
I'm not 100% sure if the patch does indeed work with MFE devices like the
HVR-3000, HVR-4000, etc because I didn't had the option to check if the
code - which checks the frontend of de device - can handle multiple
frontend device-locations.

> But I don't want to start another political fight here. All I need
> is a way to determine whether or not a device supports DVB-S2.
> If the commonly agreed on way to do this is to guess it by
> looking at FE_CAN_xyPSK capability flags, so be it. However, so
> far none of the "experts" cared about answering my initial
> question "How to determine DVB-S2 capability in S2API?", so
> I guessed the only way to get something to work was doing something
> about it ;-)
>

For the time being I have only two options which will work without any
additional patching in S2API:

- Let the user set this as an option
- Use my VUP (very ugly patch) by checking the deliverystem for the string
"DVBS2".

> Klaus

Niels Wagenaar



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
