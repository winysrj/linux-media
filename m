Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58832 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbHTMvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 08:51:00 -0400
Subject: Re: [PATCH 0/4] [media] Media entity cleanups and build fixes
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com>
 <55D5CB04.50508@xs4all.nl>
Cc: devel@driverdev.osuosl.org,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <55D5CD2D.2010607@osg.samsung.com>
Date: Thu, 20 Aug 2015 14:50:53 +0200
MIME-Version: 1.0
In-Reply-To: <55D5CB04.50508@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 08/20/2015 02:41 PM, Hans Verkuil wrote:
> On 08/19/15 17:35, Javier Martinez Canillas wrote:
>> Hello,
>>
>> This series contains a couple of build fixes and cleanups for the
>> Media Controller framework. The goal of the series is to get rid of
>> the struct media_entity .parent member since now that a media_gobj is
>> embedded into entities, the media_gobj .mdev member can be used to
>> store a pointer to the parent struct media_device.
>>
>> So the .parent field becomes redundant and can be removed after all
>> the users are converted to use entity .graph_obj.mdev instead.
>>
>> Patches 1/4 and 2/4 are build fixes I found while build testing if no
>> regressions were introduced by the conversion. Patch 3/4 converts
>> all the drivers and the MC core to use .mdev instead of .parent and
>> finally patch 4/4 removes the .parent field since now is unused.
> 
> Regarding patches 1 and 2: these should of course be merged with Mauro's
> patches that make this particular change (patch 3/8), otherwise it would
> break git bisect.
> 
> Anyway,
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com> for the changes in patch

Thanks a lot for the acks.

> 1 and 2, as long as they are added to Mauro's patch 3/8.
>

Indeed, I completely agree that these should be squashed with
Mauro's patch to maintain git bisect-ability.
 
> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
