Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40337 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbbHUHu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 03:50:29 -0400
Message-ID: <55D6D81A.9020800@xs4all.nl>
Date: Fri, 21 Aug 2015 09:49:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] [media] staging: omap4iss: get entity ID using media_entity_id()
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com> <3021244.b1huftRsSL@avalon> <55D66D4D.2030307@osg.samsung.com> <1723673.4H9JUSKm09@avalon>
In-Reply-To: <1723673.4H9JUSKm09@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 02:15 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> On Friday 21 August 2015 02:14:05 Javier Martinez Canillas wrote:
>> On 08/20/2015 08:37 PM, Laurent Pinchart wrote:
>>> On Wednesday 19 August 2015 17:35:19 Javier Martinez Canillas wrote:
>>>> The struct media_entity does not have an .id field anymore since
>>>> now the entity ID is stored in the embedded struct media_gobj.
>>>>
>>>> This caused the omap4iss driver fail to build. Fix by using the
>>>> media_entity_id() macro to obtain the entity ID.
>>>>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>
>>> This looks fine to me. The patch needs to be moved between Mauro's 1/8 and
>>> 2/8 patches to avoid breaking bisection with patch 3/8. I'd squash this
>>> patch and 2/4 into a single "media: Use media_entity_id() in drivers"
>>> patch.
>>
>> Yes, Hans and Mauro already mentioned it and I completely agree that
>> should be squashed with Mauro's patch to maintain git bisect-ability.
> 
> I wouldn't squash patches 1/4 and 2/4 into Mauro's 3/8 patch as Hans proposed, 
> but instead squashing them together into a single patch and move the result as 
> 1.5/8 in Mauro's series.
> 

I agree with Laurent, this is a better solution.

Regards,

	Hans
