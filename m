Return-path: <linux-media-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:50807
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756910Ab2JIXGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 19:06:11 -0400
Message-ID: <5074ADE4.1000302@convergeddevices.net>
Date: Tue, 9 Oct 2012 16:06:12 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <hverkuil@xs4all.nl>, <mchehab@redhat.com>,
	<sameo@linux.intel.com>, <perex@perex.cz>, <tiwai@suse.de>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] Add the main bulk of core driver for SI476x code
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <1349488502-11293-3-git-send-email-andrey.smirnov@convergeddevices.net> <20121009063349.GN8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009063349.GN8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2012 11:33 PM, Mark Brown wrote:
> On Fri, Oct 05, 2012 at 06:54:58PM -0700, Andrey Smirnov wrote:
>
>> +			err = regulator_enable(core->supplies.va);
>> +			if (err < 0)
>> +				break;
>> +			
>> +			err = regulator_enable(core->supplies.vio2);
>> +			if (err < 0)
>> +				goto disable_va;
>> +
>> +			err = regulator_enable(core->supplies.vd);
>> +			if (err < 0)
>> +				goto disable_vio2;
>> +			
>> +			err = regulator_enable(core->supplies.vio1);
>> +			if (err < 0)
>> +				goto disable_vd;
> If the sequencing is critical here you should have comments explaining
> what the requirement is, otherwise this looks like a prime candidate
> for conversion to regulator_bulk_enable() (and similarly for all the
> other regulator usage, it appears that all the regulators are worked
> with in a bulk fashion).
>

Unfortunately the datasheet is not very clear on the subject. My
suspicion at the time of writing was that since there are multiple power
domains that it was possible to power up only the ones required for
specific subsystem in use. Unfortunately I didn't and still don't have
the hardware to test it on(on the board I use there are no dedicated
regulators and the chips are always powered on). I'll convert it to the
code that uses regulators in bulk fashion.

Andrey Smirnov

