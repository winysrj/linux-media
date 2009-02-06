Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:46926 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbZBFP1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 10:27:40 -0500
Received: by nf-out-0910.google.com with SMTP id d3so144689nfc.21
        for <linux-media@vger.kernel.org>; Fri, 06 Feb 2009 07:27:37 -0800 (PST)
Date: Fri, 06 Feb 2009 11:22:22 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : Re : [linux-dvb] Re : Technotrend Budget S2-3200 Digital
 artefacts on HDchannels
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com>
	<c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
	<497F78E9.9090608@gmail.com>
	<157f4a8c0902021443s5b567aap461b50d305088699@mail.gmail.com>
	<1233839327.6096.1@manu-laptop> <498B7B3A.7050904@gmail.com>
In-Reply-To: <498B7B3A.7050904@gmail.com> (from abraham.manu@gmail.com on
	Thu Feb  5 19:50:18 2009)
Message-Id: <1233933742.9717.0@manu-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ptw+uuqZmnJNLEHHmTJR"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-ptw+uuqZmnJNLEHHmTJR
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le 05.02.2009 19:50:18, Manu Abraham a =E9crit=A0:
> Manu wrote:
> > Le 02.02.2009 18:43:33, Chris Silva a =E9crit :
> >> On Tue, Jan 27, 2009 at 9:13 PM, Manu Abraham=20
> >> <abraham.manu@gmail.com>
> >> wrote:
> >>> Alex Betis wrote:
> >>>> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham
> >> <abraham.manu@gmail.com>wrote:
> >>>>>> Hmm OK, but is there by any chance a fix for those issues
> >> somewhere or
> >>>>>> in the pipe at least? I am willing to test (as I already
> >> offered), I
> >>>>>> can compile the drivers, spread printk or whatever else is=20
> >> needed
> >> to
> >>>>>> get useful reports. Let me know if I can help sort this
> problem.
> >> BTW in
> >>>>>> my case it is DVB-S2 30000 SR and FEC 5/6.
> >>>>> It was quite not appreciable on my part to provide a fix or
> reply
> >> in
> >>>>> time nor spend much time on it earlier, but that said i was
> quite
> >>>>> stuck up with some other things.
> >>>>>
> >>>>> Can you please pull a copy of the multiproto tree
> >>>>> http://jusst.de/hg/multiproto or the v4l-dvb tree from
> >>>>> http://jusst.de/hg/v4l-dvb
> >>>>>
> >>>>> and apply the following patch and comment what your result is ?
> >>>>> Before applying please do check whether you still have the=20
> >> issues.
> >>>> Manu,
> >>>> I've tried to increase those timers long ago when played around
> >> with my card
> >>>> (Twinhan 1041) and scan utility.
> >>>> I must say that I've concentrated mostly on DVB-S channels that
> >> wasn't
> >>>> always locking.
> >>>> I didn't notice much improvements. The thing that did help was
> >> increasing
> >>>> the resolution of scan zigzags.
> >>> With regards to the zig-zag, one bug is fixed in the v4l-dvb=20
> tree.
> >>> Most likely you haven't tried that change.
> >>>
> >>>> I've sent a patch on that ML and people were happy with the
> >> results.
> >>> I did look at your patch, but that was completely against the=20
> >> tuning
> >>> algorithm.
> >>>
> >>> [..]
> >>>
> >>>> I believe DVB-S2 lock suffer from the same problem, but in that
> >> case the
> >>>> zigzag is done in the chip and not in the driver.
> >>> Along with the patch i sent, does the attached patch help you in
> >>> anyway (This works out for DVB-S2 only)?
> >>>
> >> Manu,
> >>
> >> I've tried both multiproto branches you indicated above, *with*=20
> and
> >> *without* the patches you sent to the ML (fix_iterations.patch and
> >> increase timeout.patch) on this thread.
> >> Sadly, same behavior as S2API V4L-DVB current branch. No lock on=20
> >> 30000
> >> 3/4 channels. It achieves a 0.5 second jittery sound but no image.
> It
> >> seems the driver is struggling to correctly lock on that channel,
> but
> >> doesn't get there in time... Or maybe the hardware... Dunno...
>=20
> Can you please send me a complete trace with the stb6100 and stb0899
> modules loaded with verbose=3D5 for the 30MSPS transponder what you
> are trying ? One simple szap would be enough (no scan please) based
> on the http://jusst.de/hg/v4l-dvb tree.
>=20
> Before you start testing, start clean from a cold boot after a
> powerdown. This makes it a bit more easier identify things.

OK I did just that with latest multiproto on a 11495 MHz trnaposnder,=20
DVB-S2, 30MS/s, FEC 5/6 which works using the provider's STB . I put=20
the log in attachement. You will observe a lock is acquired really=20
briefly and then nothing. Obtained using:
szap2 -t 2
I hope this can give you some data. Let me know if you need more info=20
(like putting some more printksin the source).
Bye
Manu

--=-ptw+uuqZmnJNLEHHmTJR
Content-Type: application/x-bzip; name=szap-dvbs2-nolock.txt.bz2
Content-Disposition: attachment; filename=szap-dvbs2-nolock.txt.bz2
Content-Transfer-Encoding: base64

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

--=-ptw+uuqZmnJNLEHHmTJR--
