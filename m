Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58973 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbbHUAbw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 20:31:52 -0400
Subject: Re: [PATCH 1/4] [media] staging: omap4iss: get entity ID using
 media_entity_id()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com>
 <3021244.b1huftRsSL@avalon> <55D66D4D.2030307@osg.samsung.com>
 <1723673.4H9JUSKm09@avalon>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <55D67172.7070705@osg.samsung.com>
Date: Fri, 21 Aug 2015 02:31:46 +0200
MIME-Version: 1.0
In-Reply-To: <1723673.4H9JUSKm09@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

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

I see. I don't mind either option tbh, I'm OK with whatever works better.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
