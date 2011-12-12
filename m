Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1LLUBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 15:01:05 -0500
Received: by wgbdr13 with SMTP id dr13so12013842wgb.1
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 12:01:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE6588E.4030607@deckpoint.ch>
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
	<4EE350BF.1090402@redhat.com>
	<CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
	<4EE5FF58.8060409@redhat.com>
	<CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com>
	<4EE6588E.4030607@deckpoint.ch>
Date: Tue, 13 Dec 2011 01:31:03 +0530
Message-ID: <CAHFNz9JXP9zyD6w-ALnDDDBYkZftpb98Eb03JnOmcAdmc2qcpA@mail.gmail.com>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
From: Manu Abraham <abraham.manu@gmail.com>
To: Thomas Kernen <tkernen@deckpoint.ch>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 13, 2011 at 1:09 AM, Thomas Kernen <tkernen@deckpoint.ch> wrote:
> On 12/12/11 2:40 PM, Manu Abraham wrote:
>
>>>> or is it multiplied by a factor
>>>> of 10 or was it 100 ? (Oh, my god my application Y uses a factor
>>>> of 10, the X application uses 100 and the Z application uses 1000).
>>>> What a lovely confusing scenario. ;-) (Other than for the mentioned
>>>> issue that the rolloff can be read from the SI, which is available after
>>>> tuning; for tuning you need rolloff).
>>>
>>>
>>>
>>> Sorry, but this argument doesn't make any sense to me. The same problem
>>> exists on DVB-S2 already, where several rolloffs are supported. Except
>>> if someone would code a channels.conf line in hand, the roll-off is not
>>> visible by the end user.
>>
>>
>>
>>
>> DVB-S2 as what we see as broadcast has just a single rolloff. The same
>> rolloff is used in the SI alone. It's a mistake to handle rollolff as a
>> user
>> input field. The other rolloff's are used for very specific applications,
>> such as DSNG, DVB-RCS etc, where bandwidth has to be really
>> conserved considering uplinks from trucks, vans etc; for which we don't
>> even have applications or users.
>
>
> AFAIK there is at least one card (TBS 6925) that is supporting DVB-S2
> applications aimed normally at contribution markets and whereby the rolloff
> may need to be specified.

As far as I am aware, that card uses a STV0900 or a 903,
more likely it is a STV0903 being a single input device.
The STV0900/903 chips are capable of auto detecting the
rolloff. All it needs is frequency and symbol rate.

Even if it is another different demodulator:

All the devices that I have seen which support the advanced
MODCOD's, they support auto detection of rolloff. AFAIK,
this is readable of the BBHEADER: MATYPE1, represented
by 2 bits, as specified as in the DVB-S2 specification.
There are other fields along with such as Single/Multiple
Input Streams etc.

Therefore no user intervention is required to determine
rolloff on such devices. (It is read directly off the BBHEADER
by the demod) and is available to the driver.

Regards,
Manu
