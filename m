Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47030 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbbBCPYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 10:24:35 -0500
Message-ID: <54D0E823.2070803@xs4all.nl>
Date: Tue, 03 Feb 2015 16:24:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 6/8] WmT: adv7604 driver compatibility
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <2552213.h99FiuUI04@avalon> <54CF4CD7.2060901@xs4all.nl> <7877033.djOMQDpcA0@avalon>
In-Reply-To: <7877033.djOMQDpcA0@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/15 16:22, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 02 February 2015 11:09:27 Hans Verkuil wrote:
>> On 02/02/2015 11:01 AM, Laurent Pinchart wrote:
>>> On Sunday 01 February 2015 12:26:11 Guennadi Liakhovetski wrote:
>>>> On a second thought:
>>>>
>>>> On Sun, 1 Feb 2015, Guennadi Liakhovetski wrote:
>>>>> Hi Wills,
>>>>>
>>>>> Thanks for the patch. First and foremost, the title of the patch is
>>>>> wrong. This patch does more than just adding some "adv7604
>>>>> compatibility." It's adding pad-level API to soc-camera.
>>>>>
>>>>> This is just a rough review. I'm not an expert in media-controller /
>>>>> pad-level API, I hope someone with a better knowledge of those areas
>>>>> will help me reviewing this.
>>>>>
>>>>> Another general comment: it has been discussed since a long time,
>>>>> whether a wrapper wouldn't be desired to enable a seamless use of both
>>>>> subdev drivers using and not using the pad-level API. Maybe it's the
>>>>> right time now?..
>>>>
>>>> This would be a considerable change and would most probably take a rather
>>>> long time, given how busy everyone is.
>>>
>>> If I understood correctly Hans Verkuil told me over the weekend that he
>>> wanted to address this problem in the near future. Hans, could you detail
>>> your plans ?
>>
>> That's correct. This patch series makes all the necessary changes.
>>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg83415.html
>>
>> Patches 1-4 have been merged already, but I need to do more testing for the
>> remainder. The Renesas SH7724 board is ideal for that, but unfortunately I
>> can't get it to work with the current kernel.
> 
> I can't help you much with that, but I could test changes using the rcar-vin 
> driver with the adv7180 if needed (does the adv7180 generate an image if no 
> analog source is connected ?). 

I expect so, most SDTV receivers do that.

> That will need to wait for two weeks though as 
> I don't have access to the hardware right now.
> 

It's certainly appreciated (I'll see if I can rebase it), but I am not
worried about that driver. It's soc_camera that is affected the most.

Regards,

	Hans
