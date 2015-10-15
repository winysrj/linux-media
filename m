Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56238 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbbJORrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 13:47:31 -0400
Message-ID: <561FE637.1050609@xs4all.nl>
Date: Thu, 15 Oct 2015 19:45:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 07/15] cec: add HDMI CEC framework
References: <cover.1441633456.git.hansverk@cisco.com> <60de2f33f0d4c809f06d23cdac75e3b798aaae4b.1441633456.git.hansverk@cisco.com> <20151006170635.GQ21513@n2100.arm.linux.org.uk> <561B9B1A.4020001@xs4all.nl> <20151013225147.GM32532@n2100.arm.linux.org.uk> <561DF658.3090002@xs4all.nl> <20151015173404.GG32532@n2100.arm.linux.org.uk>
In-Reply-To: <20151015173404.GG32532@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2015 07:34 PM, Russell King - ARM Linux wrote:
> On Wed, Oct 14, 2015 at 08:29:44AM +0200, Hans Verkuil wrote:
>> On 10/14/2015 12:51 AM, Russell King - ARM Linux wrote:
>>> On Mon, Oct 12, 2015 at 01:35:54PM +0200, Hans Verkuil wrote:
>>>> On 10/06/2015 07:06 PM, Russell King - ARM Linux wrote:
>>>>> Surely you aren't proposing that drivers should write directly to
>>>>> adap->phys_addr without calling some notification function that the
>>>>> physical address has changed?
>>>>
>>>> Userspace is informed through CEC_EVENT_STATE_CHANGE when the adapter is
>>>> enabled/disabled. When the adapter is enabled and CEC_CAP_PHYS_ADDR is
>>>> not set (i.e. the kernel takes care of this), then calling CEC_ADAP_G_PHYS_ADDR
>>>> returns the new physical address.
>>>
>>> Okay, so when I see the EDID arrive, I should be doing:
>>>
>>>                 phys = parse_hdmi_addr(block->edid);
>>>                 cec->adap->phys_addr = phys;
>>>                 cec_enable(cec->adap, true);
>>>
>>> IOW, you _are_ expecting adap->phys_addr to be written, but only while
>>> the adapter is disabled?
>>
>> Right.
>>
>> And when the hotplug goes down you should call cec_enable(cec->adap, false).
>> While the adapter is disabled, CEC_ADAP_G_PHYS_ADDR will always return
>> CEC_PHYS_ADDR_INVALID regardless of the cec->adap->phys_addr value.
> 
> There seems to be a few bugs.  Is there a way to monitor (in a similar
> way to tcpdump) the activity on the bus?

To monitor the bus use:

cec-ctl -m

This will monitor any CEC messages sent by the CEC adapter, any CEC broadcast
messages received and any CEC messages directed to the configured logical
address(es) of the CEC adapter.

I have yet to see hardware that can see CEC messages directed to other
devices. If your HW can do that, then it would be nice to add support for that
to the CEC framework.

> What I'm seeing is that if the TV is switched to the appropriate AV
> input, and then I do:
> 
> 	cec-ctl --playback
> 
> to use the kernel to pick up a playback logical address, I then can't
> use the remote control media playback keys until I switch away from
> the AV input and back to it.
> 

I've found cec-ctl -m very useful for debugging, it's hard to see what's
going on otherwise.

Regards,

	Hans
