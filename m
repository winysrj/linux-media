Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:62943 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbcGTMgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:36:40 -0400
Subject: Re: [PATCH] [media] rcar-vin: add legacy mode for wrong media bus
 formats
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <20160708104327.6329-1-niklas.soderlund+renesas@ragnatech.se>
 <4776c0f7-22da-6e72-f0c8-c02fc07b38dc@xs4all.nl>
 <20160720122907.GC20569@bigcity.dyn.berto.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, hans.verkuil@cisco.com,
	mchehab@kernel.org
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <578F7054.2000302@cisco.com>
Date: Wed, 20 Jul 2016 14:36:36 +0200
MIME-Version: 1.0
In-Reply-To: <20160720122907.GC20569@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 02:29 PM, Niklas Söderlund wrote:
> Hi Hans,
>
> Thanks for your feedback.
>
> On 2016-07-20 11:48:40 +0200, Hans Verkuil wrote:
>> On 07/08/2016 12:43 PM, Niklas Söderlund wrote:
>>> A recent bugfix to adv7180 brought to light that the rcar-vin driver are
>>> looking for the wrong media bus format. It was looking for a YUVU format
>>> but then expecting UYVY data. The bugfix for adv7180 will break the
>>> usage of rcar-vin together with a adv7180 as found on Renesas R-Car2
>>> Koelsch boards for example.
>>>
>>> This patch fix the rcar-vin driver to look for the correct UYVU formats
>>> and adds a legacy mode. The legacy mode is needed since I don't know if
>>> other devices provide a incorrect media bus format and I don't want to
>>> break any working configurations. Hopefully the legacy mode can be
>>> removed sometime in the future.
>>
>> I'd rather have a version without the legacy code. You have to assume that
>> subdevs return correct values otherwise what's the point of the mediabus
>> formats?
>>
>> So this is simply an adv7180 bug fix + this r-car fix to stay consistent
>> with the adv7180.
>
> On principal I agree with you. My goal with this patch is just to make
> sure there is no case where the rcar-vin driver won't work with the
> adv7180. The plan was to drop the legacy mode in a separate patch after
> both the adv7182 and rcar-vin patches where picked up.
>
> I'm happy to drop the 'legacy support' for the wrong formats from this
> patch as long as I can be sure that there is no breaking. Should I
> rewrite this patch to drop the wrong formats and submit it as a series
> together with the adv7180 patch so they can be picked up together? Or do
> you know of a better way?

Why not combine this patch and the adv7180 patch in a single patch? Just keep
Steve's Signed-off-by line together with yours. That way everything stays
in sync. The only other user of the adv7180 doesn't look at the mediabus
formats at all, so it isn't affected.

Regards,

	Hans
