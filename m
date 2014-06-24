Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbaFXOQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:16:58 -0400
Message-ID: <53A98853.10307@redhat.com>
Date: Tue, 24 Jun 2014 16:16:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>
CC: linux-media@vger.kernel.org, Alexander Sosna <alexander@xxor.de>
Subject: Re: [RFC 1/2] gspca: provide a mechanism to select a specific transfer
 endpoint
References: <53450D76.2010405@redhat.com>	<1401913499-6475-1-git-send-email-ao2@ao2.it>	<1401913499-6475-2-git-send-email-ao2@ao2.it>	<53A2F36F.9090308@redhat.com> <20140624153558.c0a933633fdb8bb20977918a@ao2.it>
In-Reply-To: <20140624153558.c0a933633fdb8bb20977918a@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/24/2014 03:35 PM, Antonio Ospite wrote:
> On Thu, 19 Jun 2014 16:27:59 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> Hi Antonio,
>>
>> Thanks for working on this.
>>
>> On 06/04/2014 10:24 PM, Antonio Ospite wrote:
>>> Add a xfer_ep_index field to struct gspca_dev, and change alt_xfer() so
>>> that it accepts a parameter which represents a specific endpoint to look
>>> for.
>>>
>>> If a subdriver wants to specify a value for gspca_dev->xfer_ep_index it
>>> can do that in its sd_config() callback.
>>>
>>> Signed-off-by: Antonio Ospite <ao2@ao2.it>
>>> ---
>>>
>>> I am not sure if it is OK to specify an endpoint _index_ or if it would be
>>> better to specify the endpoint address directly (in Kinect 0x81 is for video
>>> data and 0x82 is for depth data).
>>>
>>> Hans, any comment on that?
>>
>> I think it would be better to use the endpoint address directly for this,
>> relying on the order in which the endpoints are listed in the descriptor
>> feels wrong to me.
>>
> 
> I see.
> 
> If I declare the new field as __u8 (same type of a bEndpointAddress), I
> could mark an invalid ep address with ~(USB_ENDPOINT_DIR_MASK | 
> USB_ENDPOINT_NUMBER_MASK) in gspca_dev_probe2(), instead of using an
> int set to -1; how does that sound?

I would prefer an int with a simple -1 value of invalid.

Regards,

Hans
