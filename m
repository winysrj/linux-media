Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46306 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbbLNKeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 05:34:44 -0500
Subject: Re: [PATCH 0/3] adv7604: .g_crop and .cropcap support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <566AF904.9050102@xs4all.nl> <11156352.tBa7SdgW3Q@avalon>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <566E9B3E.7010103@xs4all.nl>
Date: Mon, 14 Dec 2015 11:34:38 +0100
MIME-Version: 1.0
In-Reply-To: <11156352.tBa7SdgW3Q@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2015 07:10 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 11 December 2015 17:25:40 Hans Verkuil wrote:
>> On 12/11/2015 05:04 PM, Ulrich Hecht wrote:
>>> Hi!
>>>
>>> The rcar_vin driver relies on these methods.  The third patch makes sure
>>> that they return up-to-date data if the input signal has changed since
>>> initialization.
>>>
>>> CU
>>> Uli
>>>
>>> Ulrich Hecht (3):
>>>   media: adv7604: implement g_crop
>>>   media: adv7604: implement cropcap
>>
>> I'm not keen on these changes. The reason is that these ops are deprecated
>> and soc-camera is - almost - the last user. The g/s_selection ops should be
>> used instead.
>>
>> Now, I have a patch that changes soc-camera to g/s_selection. The reason it
>> was never applied is that I had a hard time finding hardware to test it
>> with.
>>
>> Since you clearly have that hardware I think I'll rebase my (by now rather
>> old) patch and post it again. If you can switch the adv7604 patch to
>> g/s_selection and everything works with my patch, then I think I should
>> just make a pull request for it.
>>
>> I hope to be able to do this on Monday.
>>
>> If switching soc-camera over to g/s_selection isn't possible, then at the
>> very least your adv7604 changes should provide the g/s_selection
>> implementation. I don't want to have to convert this driver later to
>> g/s_selection.
> 
> I understand your concern and i agree with you. Our plan is to move the rcar-
> vin driver away from soc-camera. Unfortunately that will take some time, and 
> being able to use the adv7604 driver with rcar-vin would be very handy for 
> testing on some of our boards.

That would be so nice. Once rcar is converted, then we need to take a really
good look at soc-camera and decide what to do with it.

> Let's see how g/s_selection support in soc-camera works out and then decide on 
> what to do.

Ack.

	Hans

