Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41146 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbbJLLhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 07:37:50 -0400
Message-ID: <561B9B1A.4020001@xs4all.nl>
Date: Mon, 12 Oct 2015 13:35:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 07/15] cec: add HDMI CEC framework
References: <cover.1441633456.git.hansverk@cisco.com> <60de2f33f0d4c809f06d23cdac75e3b798aaae4b.1441633456.git.hansverk@cisco.com> <20151006170635.GQ21513@n2100.arm.linux.org.uk>
In-Reply-To: <20151006170635.GQ21513@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2015 07:06 PM, Russell King - ARM Linux wrote:
> On Mon, Sep 07, 2015 at 03:44:36PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The added HDMI CEC framework provides a generic kernel interface for
>> HDMI CEC devices.
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>> [k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
>> [k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
>> [k.debski@samsung.com: change kthread handling when setting logical
>> address]
>> [k.debski@samsung.com: code cleanup and fixes]
>> [k.debski@samsung.com: add missing CEC commands to match spec]
>> [k.debski@samsung.com: add RC framework support]
>> [k.debski@samsung.com: move and edit documentation]
>> [k.debski@samsung.com: add vendor id reporting]
>> [k.debski@samsung.com: add possibility to clear assigned logical
>> addresses]
>> [k.debski@samsung.com: documentation fixes, clenaup and expansion]
>> [k.debski@samsung.com: reorder of API structs and add reserved fields]
>> [k.debski@samsung.com: fix handling of events and fix 32/64bit timespec
>> problem]
>> [k.debski@samsung.com: add cec.h to include/uapi/linux/Kbuild]
>> [k.debski@samsung.com: add sequence number handling]
>> [k.debski@samsung.com: add passthrough mode]
>> [k.debski@samsung.com: fix CEC defines, add missing CEC 2.0 commands]
>> minor additions]
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I don't see much in the way of support for source devices in this:
> how do we handle hotplug of the sink, and how to do we configure the
> physical address?

The source device driver should call cec_enable(false) if the hotplug
goes down and cec_enable(true) when the EDID has been read and the physical
address has been retrieved and configured in the cec adapter.

This however assumes that the source driver is the one controlling the
CEC hardware. This is the case for the cobalt driver, but not apparently
for the exynos hardware. In that case userspace will have to handle this:
disable the CEC adapter when the hotplug disappears, set the physical address
and enable the CEC adapter when a new EDID is read.

Such drivers have the CEC_CAP_STATE and CEC_CAP_PHYS_ADDR caps set. I.e.
they expect that userspace does this.

This is also something that USB CEC dongles will do, although I don't have
a driver for that.

> Surely you aren't proposing that drivers should write directly to
> adap->phys_addr without calling some notification function that the
> physical address has changed?

Userspace is informed through CEC_EVENT_STATE_CHANGE when the adapter is
enabled/disabled. When the adapter is enabled and CEC_CAP_PHYS_ADDR is
not set (i.e. the kernel takes care of this), then calling CEC_ADAP_G_PHYS_ADDR
returns the new physical address.
 
> Please can you give some guidance on how a HDMI source bridge driver
> should deal with these issues.  Thanks.
> 

The cec.txt file will give more information about the kernel internals.
All I need is time (ha!) to update that file since the current version
is completely outdated (as mentioned in the cover letter).

Regards,

	Hans
