Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55644 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1CGVfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 16:35:33 -0500
MIME-Version: 1.0
In-Reply-To: <201103072219.32938.laurent.pinchart@ideasonboard.com>
References: <4D6D219D.7020605@matrix-vision.de>
	<AANLkTi=KncNfW0NEEoV+mrT_Ft2j-c=rQG=qbeR6tLQK@mail.gmail.com>
	<AANLkTimac512Gu0_vyPjThvNxXHsXTRD73B0d1bHnnAg@mail.gmail.com>
	<201103072219.32938.laurent.pinchart@ideasonboard.com>
Date: Mon, 7 Mar 2011 23:35:31 +0200
Message-ID: <AANLkTi=9CYUbkxaSit76OwFR=4PpH+0nDzg5vQLaV51s@mail.gmail.com>
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
From: David Cohen <dacohen@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
	Hiroshi.DOYU@nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Mar 7, 2011 at 11:19 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi David,

Hi Laurent,

>
> On Monday 07 March 2011 20:41:21 David Cohen wrote:
>> On Mon, Mar 7, 2011 at 9:25 PM, Guzman Lugo, Fernando wrote:
>> > On Mon, Mar 7, 2011 at 1:19 PM, David Cohen wrote:
>> >> On Mon, Mar 7, 2011 at 9:17 PM, Guzman Lugo, Fernando wrote:
>> >>> On Mon, Mar 7, 2011 at 7:10 AM, Michael Jones wrote:
>> >>>> From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00 2001
>> >>>> From: Michael Jones <michael.jones@matrix-vision.de>
>> >>>> Date: Mon, 7 Mar 2011 13:36:15 +0100
>> >>>> Subject: [PATCH] omap: iommu: disallow mapping NULL address
>> >>>>
>> >>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>> >>>> the NULL address if da_start==0.  Force da_start to exclude the
>> >>>> first page.
>> >>>
>> >>> what about devices that uses page 0? ipu after reset always starts
>> >>> from 0x00000000 how could we map that address??
>> >>
>> >> from 0x0? The driver sees da == 0 as error. May I ask you why do you
>> >> want it?
>> >
>> > unlike DSP that you can load a register with the addres the DSP will
>> > boot, IPU core always starts from address 0x00000000, so if you take
>> > IPU out of reset it will try to access address 0x0 if not map it,
>> > there will be a mmu fault.
>>
>> Hm. Looks like the iommu should not restrict any da. The valid da
>> range should rely only on pdata.
>> Michael, what about just update ISP's da_start on omap-iommu.c file?
>> Set it to 0x1000.
>
> What about patching the OMAP3 ISP driver to use a non-zero value (maybe -1) as
> an invalid/freed pointer ?

I wouldn't be comfortable to use 0 (or NULL) value as valid address on
ISP driver. The 'da' range (da_start and da_end) is defined per VM and
specified as platform data. IMO, to set da_start = 0x1000 seems to be
a correct approach for ISP as it's the only client for its IOMMU
instance.

Regards,

David

>
> --
> Regards,
>
> Laurent Pinchart
>
