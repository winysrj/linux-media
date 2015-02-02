Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54337 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbbBBKKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 05:10:06 -0500
Message-ID: <54CF4CD7.2060901@xs4all.nl>
Date: Mon, 02 Feb 2015 11:09:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 6/8] WmT: adv7604 driver compatibility
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <Pine.LNX.4.64.1502010028150.26661@axis700.grange> <Pine.LNX.4.64.1502011216460.9534@axis700.grange> <2552213.h99FiuUI04@avalon>
In-Reply-To: <2552213.h99FiuUI04@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2015 11:01 AM, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> On Sunday 01 February 2015 12:26:11 Guennadi Liakhovetski wrote:
>> On a second thought:
>>
>> On Sun, 1 Feb 2015, Guennadi Liakhovetski wrote:
>>> Hi Wills,
>>>
>>> Thanks for the patch. First and foremost, the title of the patch is wrong.
>>> This patch does more than just adding some "adv7604 compatibility." It's
>>> adding pad-level API to soc-camera.
>>>
>>> This is just a rough review. I'm not an expert in media-controller /
>>> pad-level API, I hope someone with a better knowledge of those areas will
>>> help me reviewing this.
>>>
>>> Another general comment: it has been discussed since a long time, whether
>>> a wrapper wouldn't be desired to enable a seamless use of both subdev
>>> drivers using and not using the pad-level API. Maybe it's the right time
>>> now?..
>>
>> This would be a considerable change and would most probably take a rather
>> long time, given how busy everyone is.
> 
> If I understood correctly Hans Verkuil told me over the weekend that he wanted 
> to address this problem in the near future. Hans, could you detail your plans 
> ?

That's correct. This patch series makes all the necessary changes.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg83415.html

Patches 1-4 have been merged already, but I need to do more testing for the
remainder. The Renesas SH7724 board is ideal for that, but unfortunately I
can't get it to work with the current kernel.

Regards,

	Hans
