Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35578 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbHYTZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 15:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <55DC0D08.10504@xs4all.nl>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<dc1be98277c46ddd87e431148fc7e332176828ab.1440359643.git.mchehab@osg.samsung.com>
	<55DC0D08.10504@xs4all.nl>
Date: Tue, 25 Aug 2015 13:25:15 -0600
Message-ID: <CAKocOOM7_mgp1ORz1mLzso9AZxSTuEcHAef64_LQ-NZVp5FASw@mail.gmail.com>
Subject: Re: [PATCH v7 11/44] [media] media: use entity.graph_obj.mdev instead
 of .parent
From: Shuah Khan <shuahkhan@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org, shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 25, 2015 at 12:36 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> The struct media_entity has a .parent field that stores a pointer
>> to the parent struct media_device. But recently a media_gobj was
>> embedded into the entities and since struct media_gojb already has
>> a pointer to a struct media_device in the .mdev field, the .parent
>> field becomes redundant and can be removed.
>>
>> This patch replaces all the usage of .parent by .graph_obj.mdev so
>> that field will become unused and can be removed on a later patch.
>>
>> No functional changes.
>>
>> The transformation was made using the following coccinelle spatch:
>>
>> @@
>> struct media_entity *me;
>> @@
>>
>> - me->parent
>> + me->graph_obj.mdev
>>
>> @@
>> struct media_entity *link;
>> @@
>>
>> - link->source->entity->parent
>> + link->source->entity->graph_obj.mdev
>>
>> @@
>> struct exynos_video_entity *ve;
>> @@
>>
>> - ve->vdev.entity.parent
>> + ve->vdev.entity.graph_obj.mdev
>>
>> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

The change looks good to me. I would really like to see a before and after
media graph with these changes, this patch and series in general.

thanks,
-- Shuah
