Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41223 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbbLGPW2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:22:28 -0500
Subject: Re: [PATCH v8 03/55] [media] omap3isp: get entity ID using
 media_entity_id()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <dc83c572e53b76ac2dffd9607d2df5b7263ed756.1440902901.git.mchehab@osg.samsung.com>
 <3875250.bDmIUeULzn@avalon>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5665A42E.5000205@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:22:22 -0300
MIME-Version: 1.0
In-Reply-To: <3875250.bDmIUeULzn@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/06/2015 12:16 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:14 Mauro Carvalho Chehab wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> Assessing media_entity ID should now use media_entity_id() macro to
> 
> Did you mean "accessing" ?
>

Yes I did, sorry for the typo. Maybe Mauro can fix it when applying?
 
>> obtain the entity ID, as a next patch will remove the .id field from
>> struct media_entity .
>>
>> So, get rid of it, otherwise the omap3isp driver will fail to build.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> With the typo fixed,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
