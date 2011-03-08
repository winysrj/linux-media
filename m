Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:30867 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab1CHJKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 04:10:37 -0500
Date: Tue, 08 Mar 2011 11:07:37 +0200 (EET)
Message-Id: <20110308.110737.81123913688742178.Hiroshi.DOYU@nokia.com>
To: dacohen@gmail.com
Cc: laurent.pinchart@ideasonboard.com, fernando.lugo@ti.com,
	michael.jones@matrix-vision.de,
	sakari.ailus@maxwell.research.nokia.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <AANLkTi=9CYUbkxaSit76OwFR=4PpH+0nDzg5vQLaV51s@mail.gmail.com>
References: <AANLkTimac512Gu0_vyPjThvNxXHsXTRD73B0d1bHnnAg@mail.gmail.com>
	<201103072219.32938.laurent.pinchart@ideasonboard.com>
	<AANLkTi=9CYUbkxaSit76OwFR=4PpH+0nDzg5vQLaV51s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: ext David Cohen <dacohen@gmail.com>
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
Date: Mon, 7 Mar 2011 23:35:31 +0200

> On Mon, Mar 7, 2011 at 11:19 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi David,
> 
> Hi Laurent,
> 
>>
>> On Monday 07 March 2011 20:41:21 David Cohen wrote:
>>> On Mon, Mar 7, 2011 at 9:25 PM, Guzman Lugo, Fernando wrote:
>>> > On Mon, Mar 7, 2011 at 1:19 PM, David Cohen wrote:
>>> >> On Mon, Mar 7, 2011 at 9:17 PM, Guzman Lugo, Fernando wrote:
>>> >>> On Mon, Mar 7, 2011 at 7:10 AM, Michael Jones wrote:
>>> >>>> From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00 2001
>>> >>>> From: Michael Jones <michael.jones@matrix-vision.de>
>>> >>>> Date: Mon, 7 Mar 2011 13:36:15 +0100
>>> >>>> Subject: [PATCH] omap: iommu: disallow mapping NULL address
>>> >>>>
>>> >>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>>> >>>> the NULL address if da_start==0.  Force da_start to exclude the
>>> >>>> first page.
>>> >>>
>>> >>> what about devices that uses page 0? ipu after reset always starts
>>> >>> from 0x00000000 how could we map that address??
>>> >>
>>> >> from 0x0? The driver sees da == 0 as error. May I ask you why do you
>>> >> want it?
>>> >
>>> > unlike DSP that you can load a register with the addres the DSP will
>>> > boot, IPU core always starts from address 0x00000000, so if you take
>>> > IPU out of reset it will try to access address 0x0 if not map it,
>>> > there will be a mmu fault.
>>>
>>> Hm. Looks like the iommu should not restrict any da. The valid da
>>> range should rely only on pdata.
>>> Michael, what about just update ISP's da_start on omap-iommu.c file?
>>> Set it to 0x1000.
>>
>> What about patching the OMAP3 ISP driver to use a non-zero value (maybe -1) as
>> an invalid/freed pointer ?
> 
> I wouldn't be comfortable to use 0 (or NULL) value as valid address on
> ISP driver. The 'da' range (da_start and da_end) is defined per VM and
> specified as platform data. IMO, to set da_start = 0x1000 seems to be
> a correct approach for ISP as it's the only client for its IOMMU
> instance.

Sounds reasonable to me too. Considering 'da == 0' as invalid can be
reasonably acceptable intuitively in most cases, and just let it
allowed theoretically.
