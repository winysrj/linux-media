Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50077 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1LLD7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 22:59:06 -0500
Received: by wgbdr13 with SMTP id dr13so10468563wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 19:59:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE350BF.1090402@redhat.com>
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
	<4EE350BF.1090402@redhat.com>
Date: Mon, 12 Dec 2011 09:29:04 +0530
Message-ID: <CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 10, 2011 at 5:59 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 10-12-2011 02:43, Manu Abraham wrote:
>
>
>> From 92a79a1e0a1b5403f06f60661f00ede365b10108 Mon Sep 17 00:00:00 2001
>> From: Manu Abraham <abraham.manu@gmail.com>
>> Date: Thu, 24 Nov 2011 17:09:09 +0530
>> Subject: [PATCH 06/10] DVB: Use a unique delivery system identifier for
>> DVBC_ANNEX_C,
>>  just like any other. DVBC_ANNEX_A and DVBC_ANNEX_C have slightly
>>  different parameters and used in 2 geographically different
>>  locations.
>>
>> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
>> ---
>>  include/linux/dvb/frontend.h |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
>> index f80b863..a3c7623 100644
>> --- a/include/linux/dvb/frontend.h
>> +++ b/include/linux/dvb/frontend.h
>> @@ -335,7 +335,7 @@ typedef enum fe_rolloff {
>>
>>  typedef enum fe_delivery_system {
>>        SYS_UNDEFINED,
>> -       SYS_DVBC_ANNEX_AC,
>> +       SYS_DVBC_ANNEX_A,
>>        SYS_DVBC_ANNEX_B,
>>        SYS_DVBT,
>>        SYS_DSS,
>> @@ -352,8 +352,13 @@ typedef enum fe_delivery_system {
>>        SYS_DAB,
>>        SYS_DVBT2,
>>        SYS_TURBO,
>> +       SYS_DVBC_ANNEX_C,
>>  } fe_delivery_system_t;
>>
>> +
>> +#define SYS_DVBC_ANNEX_AC      SYS_DVBC_ANNEX_A
>> +
>> +
>>  struct dtv_cmds_h {
>>        char    *name;          /* A display name for debugging purposes */
>
>
> This patch conflicts with the approach given by this patch:
>
>        http://www.mail-archive.com/linux-media@vger.kernel.org/msg39262.html
>
> merged as commit 39ce61a846c8e1fa00cb57ad5af021542e6e8403.
>

- For correct delivery system handling, the delivery system identifier
should be unique. Otherwise patch 01/10 is meaningless for devices
with DVBC_ANNEX_C, facing the same situations.

- Rolloff is provided only in the SI table and is not known prior to a
tune. So users must struggle to find the correct rolloff. So users
must know beforehand their experience what rolloff it is rather than
reading Service Information, which is broken by approach. It is much
easier for a user to state that he is living in Japan or some other
place which is using ANNEX_C, rather than creating confusion that
he has to use DVBC and rolloff of 0.15 or is it multiplied by a factor
of 10 or was it 100 ? (Oh, my god my application Y uses a factor
of 10, the X application uses 100 and the Z application uses 1000).
What a lovely confusing scenario. ;-) (Other than for the mentioned
issue that the rolloff can be read from the SI, which is available after
tuning; for tuning you need rolloff).

Really sexy setup indeed. ;-)

One thing that I should warn/mention to you is the lack of clarity on
what you say. You say that you want more discussion, but you
whack in patches which is never discussed, breaking many logical
concepts and ideas and broken by nature. How do you justify
yourself ? I don't think you can justify yourself.


> The approach there were to allow calls to SYS_DVBC_ANNEX_AC to replace the
> Annex A
> roll-off factor of 0.15 by the one used on Annex C (0.13).
>
> As this patch didn't show-up at an stable version, we can still change it to
> use a
> separate delivery system for DVB-C annex C, but this patch needs to be
> reverted, and
> a few changes on existing drivers are needed (drxk, xc5000 and tda18271c2dd
> explicitly
> supports both standards).
>

As I mentioned earlier, the patches were sent in the order that was
being worked upon. It is not complete, for all devices that are using
DVBC_ANNEX_C. Only the TDA18271, TDA18271DD were worked upon
initially.
