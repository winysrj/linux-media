Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38629 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbbHTMpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 08:45:49 -0400
Message-ID: <55D5CB5F.2010106@xs4all.nl>
Date: Thu, 20 Aug 2015 14:43:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
CC: =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	devel@driverdev.osuosl.org, Kukjin Kim <kgene@kernel.org>,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] media: use entity.graph_obj.mdev instead
 of .parent
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com> <1439998526-12832-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1439998526-12832-4-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 17:35, Javier Martinez Canillas wrote:
> The struct media_entity has a .parent field that stores a pointer
> to the parent struct media_device. But recently a media_gobj was
> embedded into the entities and since struct media_gojb already has
> a pointer to a struct media_device in the .mdev field, the .parent
> field becomes redundant and can be removed.
> 
> This patch replaces all the usage of .parent by .graph_obj.mdev so
> that field will become unused and can be removed on a later patch.
> 
> No functional changes.
> 
> The transformation was made using the following coccinelle spatch:
> 
> @@
> struct media_entity *me;
> @@
> 
> - me->parent
> + me->graph_obj.mdev
> 
> @@
> struct media_entity *link;
> @@
> 
> - link->source->entity->parent
> + link->source->entity->graph_obj.mdev
> 
> @@
> struct exynos_video_entity *ve;
> @@
> 
> - ve->vdev.entity.parent
> + ve->vdev.entity.graph_obj.mdev
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
