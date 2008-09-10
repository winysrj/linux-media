Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdUVI-0000Xl-VC
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 20:33:26 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Z00FX6SUF1OC1@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 14:32:45 -0400 (EDT)
Date: Wed, 10 Sep 2008 14:32:39 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809101710.19695.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48C812C7.2090004@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org> <200809101340.09702.hftom@free.fr>
	<48C7CDCF.9090300@hauppauge.com> <200809101710.19695.hftom@free.fr>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Thommeret wrote:
> Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit :
>>> Is this card able to deliver both S and T at the same time?
>> No, the hardware can do S/S2 or T.
> =

>> The driver in the S2API tree only has S/S2 enabled (for the time being).
> =

> So, maybe we have to think a bit about how to add support for this kind o=
f =

> device.

This is already in progress, based on some work I did on the HVR3000 =

bus-sharing changes a couple of years ago =

(http://linuxtv.org/hg/~stoth/hvr3000). People are interested in seeing =

this merged. Darron Board took the patches a long time ago and has been =

maintaining them. (Thank you)

What does this mean? Well, this is what it looks like to the applications:

/dev/dvb/adapter0/frontend0 DVB-S
/dev/dvb/adapter0/frontend1 DVB-T

I floated these patches in the linux-dvb mailing list a long time ago =

and the general feeling was of support for this approach.

I'm told myth already supports this. If anyone has experience running an =

HVR3000 with both DVB-T and DVB-T on Myth then I'd welcome their =

feedback here.


> I mean, if the driver provides different adapters/frontends (say =

> adapter0/frontend0 and adapter1/frontend0), a typical application will se=
e =

> these as separate devices, and then when a user watch a S channel, the ap=
p =

> assumes that the T frontend is free while in fact it's not.
> For example, Kaffeine updates its channels list according to which channe=
ls =

> can be viewed (based on which frontends are free). So, if you are recordi=
ng a =

> S channel, all channels on this freq are shown as available and all T =

> channels are also shown as available. But in the HVR4000 case, it's false=
, =

> since the T tuner isn't free.
> =

> Maybe a solution could be to have :
> - adapter0/frontend0 -> S/S2 tuner
> - adapter0/frontend1 -> T tuner

Correct, this : http://linuxtv.org/hg/~stoth/hvr3000/rev/3f78be7007f6

Quoting the original patch description:

"Multiple frontends on a single adapter support.

From: Steven Toth <stoth@hauppauge.com>

These patches are for review only.

The WinTV-HVR3000 has a single transport bus which is shared between
a DVB-T and DVB-S modulator. These patches build on the bus acquisition
cx88 work from a few weeks ago to add support for this.

So to applications the HVR3000 looks like this:
/dev/dvb/adapter0/fe0 (cx24123 DVB-S demod)
/dev/dvb/adapter0/fe1 (cx22702 DVB-T demod)

Additional boards continue as before, eg:
/dev/dvb/adapter1/fe0 (lgdt3302 ATSC demod)

The basic change is removing the single instance of the videobuf_dvb in
cx8802_dev and saa7134_dev(?) and replacing it with a list and some
supporting functions.

*NOTE* This branch was taken before v4l-dvb was closed for 2.6.19 so
two or three current cx88 patches appear to be reversed by this tree,
this will be cleaned up in the near future. The patches missing change
the mutex handing to core->lock, fix an enumeration problem.

For Review: The best place to start reviewing this patch
is videobuf_dvb. These core structures and functions are then implemented
in cx88 and (partially in) saa7134.

Signed-off-by: Steven Toth <stoth@hauppauge.com>"



> =

> So applications could know that these 2 frontends are exclusive.
> That would not require any API change, but would have to be a rule follow=
ed by =

> all drivers.
> =

> =


This would be a nice addition to the S2API tree. I'll collect the new =

patches and present another patchset for review.

S2API is shaping up nicely, we just have to make sure we don't overload =

the tree and lose sight of the basic goal.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
