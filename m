Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41215 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbbLGPTM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:19:12 -0500
Subject: Re: [PATCH 1/5] [media] staging: omap4iss: separate links creation
 from entities init
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
 <1441296036-20727-2-git-send-email-javier@osg.samsung.com>
 <2776235.DqjovJkOTH@avalon>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5665A368.4030404@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:19:04 -0300
MIME-Version: 1.0
In-Reply-To: <2776235.DqjovJkOTH@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/06/2015 12:10 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
>

Thanks for your feedback.
 
> On Thursday 03 September 2015 18:00:32 Javier Martinez Canillas wrote:
>> The omap4iss driver initializes the entities and creates the pads links
>> before the entities are registered with the media device. This does not
>> work now that object IDs are used to create links so the media_device
>> has to be set.
>>
>> Split out the pads links creation from the entity initialization so are
>> made after the entities registration.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>>  drivers/staging/media/omap4iss/iss.c         | 101 +++++++++++++++---------
>>  drivers/staging/media/omap4iss/iss_csi2.c    |  35 +++++++---
>>  drivers/staging/media/omap4iss/iss_csi2.h    |   1 +
>>  drivers/staging/media/omap4iss/iss_ipipeif.c |  29 ++++----
>>  drivers/staging/media/omap4iss/iss_ipipeif.h |   1 +
>>  drivers/staging/media/omap4iss/iss_resizer.c |  29 ++++----
>>  drivers/staging/media/omap4iss/iss_resizer.h |   1 +
>>  7 files changed, 132 insertions(+), 65 deletions(-)
>>
>> diff --git a/drivers/staging/media/omap4iss/iss.c
>> b/drivers/staging/media/omap4iss/iss.c index 44b88ff3ba83..076ddd412201
>> 100644
>> --- a/drivers/staging/media/omap4iss/iss.c
>> +++ b/drivers/staging/media/omap4iss/iss.c
>> @@ -1272,6 +1272,68 @@ done:
>>  	return ret;
>>  }
>>
>> +/*
>> + * iss_create_pads_links() - Pads links creation for the subdevices
> 
> Could you please s/pads_links/links/ and s/pads links/links/ ?
>

Yes, as mentioned in the other thread, I'll do that for all the
drivers that only create pad links.
 
> Apart from that,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks!

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
