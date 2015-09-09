Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbbIIIaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 04:30:16 -0400
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work queue
To: Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.1509081035070.1533-100000@iolanthe.rowland.org>
Cc: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, linux-usb@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <55EFEE14.5050100@redhat.com>
Date: Wed, 9 Sep 2015 10:30:12 +0200
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1509081035070.1533-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08-09-15 16:36, Alan Stern wrote:
> On Tue, 8 Sep 2015, Hans de Goede wrote:
>
>> Hi,
>>
>> On 09/07/2015 06:23 PM, Mian Yousaf Kaukab wrote:
>>> urb completion callback is executed in host controllers interrupt
>>> context. To keep preempt disable time short, add urbs to a list on
>>> completion and schedule work to process the list.
>>>
>>> Moreover, save timestamp and sof number in the urb completion callback
>>> to avoid any delays.
>>
>> Erm, I thought that we had already moved to using threaded interrupt
>> handling for the urb completion a while (1-2 years ?) back. Is this then
>> still needed ?
>
> We moved to handling URB completions in a tasklet, not a threaded
> handler.

Right.

> (Similar idea, though.)  And the change was made in only one
> or two HCDs, not in all of them.

Ah, I was under the impression this was a core change, not a per
hcd change.

Regards,

Hans
