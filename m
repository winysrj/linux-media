Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:4553 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab0BCJnp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 04:43:45 -0500
Message-ID: <4B694545.2090302@pelagicore.com>
Date: Wed, 03 Feb 2010 10:43:33 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com>
In-Reply-To: <4B693ED7.4060401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/2010 10:16 AM, Mauro Carvalho Chehab wrote:
> Hi Richard,
>
> Richard Röjfors wrote:
>> The timberdale FPGA is found on the Intel in-Vehicle Infotainment reference board
>> russelville.
>>
>> The driver is a PCI driver which chunks up the I/O memory and distributes interrupts
>> to a number of platform devices for each IP inside the FPGA.
>>
>> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
>
> I'm not sure how to deal with this patch. It doesn't contain anything related
> to V4L2 inside it, nor it applies to drivers/media,

Sorry my address book tricked me. I was suppose to send it to LKML not the
Media mailing list.

I will resend the patch with the correct addresses in it.

 > but it depends on the radio-timb driver that you submitted us.

Actually this MFD has more devices than in the current patch. These will
be incrementally added when the corresponding drivers goes into the kernel.

Sorry for the inconvenience.
--Richard

