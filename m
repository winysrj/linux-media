Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41231 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbbLGPYk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:24:40 -0500
Subject: Re: [PATCH v8 02/55] [media] staging: omap4iss: get entity ID using
 media_entity_id()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <95dccc89e638c5cd60a6d13541efd29ca39766fb.1440902901.git.mchehab@osg.samsung.com>
 <11605234.UyDltQlPdy@avalon>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5665A4B3.2090809@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:24:35 -0300
MIME-Version: 1.0
In-Reply-To: <11605234.UyDltQlPdy@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/06/2015 12:18 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:13 Mauro Carvalho Chehab wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> Assessing media_entity ID should now use media_entity_id() macro to
> 
> Did you mean "accessing" ?
>

Sigh, yet another typo error that seems to be due copy and paste.
 
>> obtain the entity ID, as a next patch will remove the .id field from
>> struct media_entity .
>>
>> So, get rid of it, otherwise the omap4iss driver will fail to build.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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
