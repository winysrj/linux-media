Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab1LLNTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 08:19:24 -0500
Message-ID: <4EE5FF58.8060409@redhat.com>
Date: Mon, 12 Dec 2011 11:19:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier
 for DVBC_ANNEX_C
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com> <4EE350BF.1090402@redhat.com> <CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
In-Reply-To: <CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12-12-2011 01:59, Manu Abraham wrote:
> On Sat, Dec 10, 2011 at 5:59 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> On 10-12-2011 02:43, Manu Abraham wrote:
>>
>>
>>>  From 92a79a1e0a1b5403f06f60661f00ede365b10108 Mon Sep 17 00:00:00 2001
>>> From: Manu Abraham<abraham.manu@gmail.com>
>>> Date: Thu, 24 Nov 2011 17:09:09 +0530
>>> Subject: [PATCH 06/10] DVB: Use a unique delivery system identifier for
>>> DVBC_ANNEX_C,
>>>   just like any other. DVBC_ANNEX_A and DVBC_ANNEX_C have slightly
>>>   different parameters and used in 2 geographically different
>>>   locations.
>>>
>>> Signed-off-by: Manu Abraham<abraham.manu@gmail.com>
>>> ---
>>>   include/linux/dvb/frontend.h |    7 ++++++-
>>>   1 files changed, 6 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
>>> index f80b863..a3c7623 100644
>>> --- a/include/linux/dvb/frontend.h
>>> +++ b/include/linux/dvb/frontend.h
>>> @@ -335,7 +335,7 @@ typedef enum fe_rolloff {
>>>
>>>   typedef enum fe_delivery_system {
>>>         SYS_UNDEFINED,
>>> -       SYS_DVBC_ANNEX_AC,
>>> +       SYS_DVBC_ANNEX_A,
>>>         SYS_DVBC_ANNEX_B,
>>>         SYS_DVBT,
>>>         SYS_DSS,
>>> @@ -352,8 +352,13 @@ typedef enum fe_delivery_system {
>>>         SYS_DAB,
>>>         SYS_DVBT2,
>>>         SYS_TURBO,
>>> +       SYS_DVBC_ANNEX_C,
>>>   } fe_delivery_system_t;
>>>
>>> +
>>> +#define SYS_DVBC_ANNEX_AC      SYS_DVBC_ANNEX_A
>>> +
>>> +
>>>   struct dtv_cmds_h {
>>>         char    *name;          /* A display name for debugging purposes */
>>
>>
>> This patch conflicts with the approach given by this patch:
>>
>>         http://www.mail-archive.com/linux-media@vger.kernel.org/msg39262.html
>>
>> merged as commit 39ce61a846c8e1fa00cb57ad5af021542e6e8403.
>>
>
> - For correct delivery system handling, the delivery system identifier
> should be unique. Otherwise patch 01/10 is meaningless for devices
> with DVBC_ANNEX_C, facing the same situations.

This is a good point.
>
> - Rolloff is provided only in the SI table and is not known prior to a
> tune. So users must struggle to find the correct rolloff. So users
> must know beforehand their experience what rolloff it is rather than
> reading Service Information, which is broken by approach. It is much
> easier for a user to state that he is living in Japan or some other
> place which is using ANNEX_C, rather than creating confusion that
> he has to use DVBC and rolloff of 0.15

Userspace can present it as Japan and hide the technical details. Most
applications do that already: kaffeine, w_scan, ...

The dvb-apps utils don't do it, but the scan file format it produces
doesn't support anything besides DVB-C/DVB-S/DVB-T/ATSC anyway.

> or is it multiplied by a factor
> of 10 or was it 100 ? (Oh, my god my application Y uses a factor
> of 10, the X application uses 100 and the Z application uses 1000).
> What a lovely confusing scenario. ;-) (Other than for the mentioned
> issue that the rolloff can be read from the SI, which is available after
> tuning; for tuning you need rolloff).

Sorry, but this argument doesn't make any sense to me. The same problem
exists on DVB-S2 already, where several rolloffs are supported. Except
if someone would code a channels.conf line in hand, the roll-off is not
visible by the end user.

> Really sexy setup indeed. ;-)
>
> One thing that I should warn/mention to you is the lack of clarity on
> what you say. You say that you want more discussion, but you
> whack in patches which is never discussed, breaking many logical
> concepts and ideas and broken by nature. How do you justify
> yourself ? I don't think you can justify yourself.

If we have a consensus around your approach, I'm OK to move for it,
provided that it doesn't cause regressions upstream.

As I said, this requires reviewing all DVB frontends to be sure that
they won't break, especially if is there any that it is capable of
auto-detecting the roll-off factor.

Both approaches have advantages and disadvantages.

The main advantage of my approach is that it is coherent with the current
DVBv5 API (e. g. SYS_DVBC_ANNEX_AC). So, the only changes are at the
frontends that need to decide between Annex A and Annex C (currently, only
drx-k - and the tuners used with it).

Advantages on your approach:
	- Cleaner for the userspace API;
	- It is possible to add Annex C only devices.
Disadvantages:
	- Need to deprecate the existing SYS_DVBC_ANNEX_AC;
	- The alias that SYS_DVBC_ANNEX_AC means only SYS_DVBC_ANNEX_A might
	  break some thing;
	- Requires further changes at the DocBook API description;
	- Need to review all DVB-C frontends.

If we're willing to take your approach, we need a patch series that addresses
all DVB-C frontends, to be sure that no regressions were added due to the change
ofSYS_DVBC_ANNEX_AC meaning.

It also requires that FE_QAM to be mapped to be both SYS_DVBC_ANNEX_A and SYS_DVBC_ANNEX_C,
if isn't there any issue for it to work with Annex C mode, or to just
SYS_DVBC_ANNEX_A, if there is enough confidence that such device doesn't
work at allwith annex C.

>> The approach there were to allow calls to SYS_DVBC_ANNEX_AC to replace the
>> Annex A
>> roll-off factor of 0.15 by the one used on Annex C (0.13).
>>
>> As this patch didn't show-up at an stable version, we can still change it to
>> use a
>> separate delivery system for DVB-C annex C, but this patch needs to be
>> reverted, and
>> a few changes on existing drivers are needed (drxk, xc5000 and tda18271c2dd
>> explicitly
>> supports both standards).
>>
>
> As I mentioned earlier, the patches were sent in the order that was
> being worked upon. It is not complete, for all devices that are using
> DVBC_ANNEX_C. Only the TDA18271, TDA18271DD were worked upon
> initially.

Ok. As I said, it is possible to change to your approach, but it requires
a patch series that addresses the frontends that currently supports DVB-C.
There aren't many, so maybe this is not much work.

$ git grep -l FE_QAM drivers/media/dvb/frontends/ drivers/media/common/tuners/
drivers/media/common/tuners/tda18271-fe.c
drivers/media/common/tuners/tda827x.c
drivers/media/common/tuners/tuner-xc2028.c
drivers/media/common/tuners/xc5000.c
drivers/media/dvb/frontends/cxd2820r_core.c
drivers/media/dvb/frontends/drxk_hard.c
drivers/media/dvb/frontends/dvb_dummy_fe.c
drivers/media/dvb/frontends/stv0297.c
drivers/media/dvb/frontends/stv0367.c
drivers/media/dvb/frontends/tda10021.c
drivers/media/dvb/frontends/tda10023.c
drivers/media/dvb/frontends/tda18271c2dd.c
drivers/media/dvb/frontends/ves1820.c

I did a quick research at the Internet for the above:
	- tda827x has just a frequency table. Nothing needs to change
	  there;
	- xc2028 is a false hit: itdoesn't implement DVB-C;
	- cxd2820r says: Integrated matched filter 0.15 roll-off factor
		http://www.framos-imaging.com/fileadmin/img/sony_cxd2820r.pdf
	- dvb_dummy_fe doesn't need changes;
	- tda18271, xc5000, drxk and tda18271c2dd for sure require changes;
	- stv0297 is fully compliant with ITU-T J.83 Annexes A/C, according
	  to:
		http://www.st.com/internet/imag_video/product/159180.jsp
	- stv0367 is fully compliant with ITU-T J.83 Annexes A/C, according
	  with its data brief:
		http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/DATA_BRIEF/DM00030322.pdf

	- tda10021 datasheet says that it has a programmable half
	Nyquist filter (roll off = 0.15 or 0.13):
		http://www.datasheetcatalog.org/datasheet/philips/TDA10021.pdf
	- tda10023 factsheet says that it is Fully compliant DVB-C (Annex A and C)
	  and MCNS (Annex B) decoders:
		http://www.datasheetarchive.com/indexdl/Datasheets-DAV2/DSADA0022343.pdf
	- vez1820 says Half Nyquist filters (roll off = 15 %).
	- xc5000, drxk and tda18271c2dd drivers are prepared to support both
	  standards;
	- tda18271 is a worldwide tuner that supports all ITU-T J.83 annexes.
	  it requires the same approach used on xc5000/tda18271c2dd drivers to
	  adjust the low-pass filter based on signal rate and roll-off factor.

In summary:

It seems that there are two Annex A-only frontends: cxd2820r and ves1820.
All the others are dual Annex A/Annex C.

This is actually a very good reason to implement your approach,
as otherwise, it would be hard for userspace to detect that those
two devices that lack Annex C.

This also means that just doing an alias from FE_QAM and SYS_DVBC_ANNEX_AC to
SYS_DVBC_ANNEX_A may break something, as, for most devices, SYS_DVBC_ANNEX_AC
really means both Annex A and C.

I didn't look inside the drivers for stv0297, stv0367, tda10021 and tda10023.
I suspect that some will need an additional code to change the roll-off, based on
the delivery system.


Regards,
Mauro
