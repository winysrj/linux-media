Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54225 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3APVhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 16:37:22 -0500
Received: by mail-ob0-f181.google.com with SMTP id oi10so1891486obb.12
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 13:37:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2817386.vHx2V41lNt@f17simon>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
Date: Thu, 17 Jan 2013 03:07:21 +0530
Message-ID: <CAHFNz9K7EJWjmeU8ViW_bnxO-inNuSU4S+=vH_FHnCF9Aq+kBg@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:59 AM, Simon Farnsworth
<simon.farnsworth@onelan.com> wrote:
> On Wednesday 16 January 2013 23:56:48 Manu Abraham wrote:
>> On Wed, Jan 16, 2013 at 10:51 PM, Mauro Carvalho Chehab
> <snip>
>> >
>> > It is a common sense that the existing API is broken. If my proposal
>> > requires adjustments, please comment on each specific patchset, instead
>> > of filling this thread of destructive and useless complains.
>>
>>
>> No, the concept of such a generalization is broken, as each new device will
>> be different and trying to make more generalization is a waste of developer
>> time and effort. The simplest approach would be to do a coarse approach,
>> which is not a perfect world, but it will do some good results for all the
>> people who use Linux-DVB. Still, repeating myself we are not dealing with
>> high end professional devices. If we have such devices, then it makes sense
>> to start such a discussion. Anyway professional devices will need a lot of
>> other API extensions, so your arguments on the need for professional
>> devices that do not exist are pointless and not agreeable to.
>>
> Let's step back a bit. As a sophisticated API user, I want to be able to give
> my end-users the following information:
>
>  * Signal strength in dBm
>  * Signal quality as "poor", "OK" and "good".
>  * Ideally, "increase signal strength to improve things" or "attenuate signal
> to improve things"
>
> In a DVBv3 world, "poor" equates to UNC != 0, "OK" is UNC == 0, BER != 0,
> and "good" is UNC == BER == 0. The idea is that a user seeing "poor" knows
> that they will see glitches in the output; a user seeing "OK" knows that
> there's no glitching right now, but that the setup is marginal and may
> struggle if anything changes, and a user seeing "good" knows that they've got
> high quality signal.
>
> VDR wants even simpler - it just wants strength and quality on a 0 to 100
> scale, where 100 is perfect, and 0 is nothing present.
>
> In both cases, we want per-layer quality for ISDB-T, for the reasons you've
> already outlined.
>
> So, how do you provide such information? Is it enough to simply provide
> strength in dBm, and quality as 0 to 100, where anything under 33 indicates
> uncorrected errors, and anything under 66 indicates that quality is marginal?

With DVB v3 the stats are interpreted thus:

http://linuxtv.org/downloads/legacy/old/linux_dvb_api-20020304.pdf

But, I am also not a big fan of that, but nevertheless it would have worked if
the drivers complied to that specification. The important thing that we learn
from history is that with a multitude of devices with different topologies and
methodologies, it is too hard to achieve a rigid structure.

Given the following statistical information available:

status 0x1f --- The demodulator status bits. 0x1f means all bits set,
everything ok.

signal [0x0000...0xffff] --- Signal Strength.
snr [0x0000...0xffff] --- Signal/Noise Ratio.

ber [0...0xffffffff] --- Bit Error Rate. The less the better.
unc [0...0xffffffff] --- Number of Uncorrectable Blocks. Small numbers
are preferable.


With ISDB-T, with the 3 layers, you have BER/UNC for each of the layers, though
the rate difference could be very little.

For one layer, you could map the details as is, into the existing convention,
while the other 2 could be retrieved querying the details for each of
the layers.
This will keep it simple, to avoid calculating values to try to make a
global value.
Care should be taken, as to not change the current behaviour.
That way, all applications will be happy and still be working as is,
while you will
get detailed information on a per-layer basis.

Now, to achieve a common standard, the values need to be fit into the window,
what most drivers are trying to do. In most cases, it could be
difficult to convert
from one format to another one in it's current form, without causing
real breakage
to existing drivers. That said for each of the drivers, it couldn't be
difficult to
convert to a relative scale say something like a 0-100% scale, without dBuV,
or mV or dB/10, or dB/100. There can be a zillion reason why a demodulator
is using a scale in it's driver. It might not be easy or make sense to
change those
values to a newer scale. But it wouldn't be that hard to scale those
to a relative scale.
In fact many or quite a lot of drivers while providing the information
in some specific
form are also in that relative form.

Does everyone working on the DVB drivers posses a spectrum analyzer to do
calibration to dBwhatever ? At my side, I have had access to one some
time back,
but not anymore.

As Klaus said, any idiot will understand the relative scale clearly,
without much
after thought. This will also help that all the developers need to see are the
maxima / minima, which could be easy.

This is userspace requesting to make things simpler, not to make it even more
worser.

Manu
