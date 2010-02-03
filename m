Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab0BCJzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 04:55:31 -0500
Message-ID: <4B69471C.6040105@redhat.com>
Date: Wed, 03 Feb 2010 07:51:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: "Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com> <4B694545.2090302@pelagicore.com>
In-Reply-To: <4B694545.2090302@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Richard Röjfors wrote:
> On 02/03/2010 10:16 AM, Mauro Carvalho Chehab wrote:
>> Hi Richard,
>>
>> Richard Röjfors wrote:
>>> The timberdale FPGA is found on the Intel in-Vehicle Infotainment
>>> reference board
>>> russelville.
>>>
>>> The driver is a PCI driver which chunks up the I/O memory and
>>> distributes interrupts
>>> to a number of platform devices for each IP inside the FPGA.
>>>
>>> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
>>
>> I'm not sure how to deal with this patch. It doesn't contain anything
>> related
>> to V4L2 inside it, nor it applies to drivers/media,
> 
> Sorry my address book tricked me. I was suppose to send it to LKML not the
> Media mailing list.
> 
> I will resend the patch with the correct addresses in it.
> 
>> but it depends on the radio-timb driver that you submitted us.
> 
> Actually this MFD has more devices than in the current patch. These will
> be incrementally added when the corresponding drivers goes into the kernel.

Ah, ok.

> Sorry for the inconvenience.

No problem.

-- 

Cheers,
Mauro
