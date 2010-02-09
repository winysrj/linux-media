Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:49033 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab0BIWDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 17:03:49 -0500
Received: from ipb2.telenor.se (195.54.127.165) by proxy3.bredband.net (7.3.140.3)
        id 4AD3E1BA03180E05 for linux-media@vger.kernel.org; Tue, 9 Feb 2010 22:43:39 +0100
Message-ID: <4B71D70A.6030806@pelagicore.com>
Date: Tue, 09 Feb 2010 22:43:38 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com> <20100203100326.GA3460@sortiz.org> <4B694D69.1090201@redhat.com> <20100203123617.GF3460@sortiz.org> <4B69B12D.6030105@redhat.com> <20100204092846.GA3336@sortiz.org>
In-Reply-To: <20100204092846.GA3336@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/4/10 10:28 AM, Samuel Ortiz wrote:
> On Wed, Feb 03, 2010 at 05:23:57PM +0000, Mauro Carvalho Chehab wrote:
>>> Ok, thanks again for your understanding. This is definitely material for the
>>> next merge window, so I'll merge it into my for-next branch.
>>
>> The last version of the driver is OK for merging. However, I noticed one issue:
>> it depends on two drivers that were already merged on my tree:
>>
>> +config RADIO_TIMBERDALE
>> +       tristate "Enable the Timberdale radio driver"
>> +       depends on MFD_TIMBERDALE && VIDEO_V4L2
>> +       select RADIO_TEF6862
>> +       select RADIO_SAA7706H
>>
>> Currently, the dependency seems to happen only at Kconfig level.
>>
>> Maybe the better is to return to the previous plan: apply it via my tree, as the better
>> is to have it added after those two radio i2c drivers.
> I'm fine with that. Richard sent me a 2nd version of his patch that I was
> about to merge.
> Richard, could you please post this patch here, or to lkml with Mauro cc'ed ?
> I'll add my SOB to it and then it will go through Mauro's tree.

Now when the radio driver made it into the media tree, can I post an
updated MFD which defines these drivers too?
Is a complete MFD patch preferred, or just an incremental against the
last one?

--Richard
