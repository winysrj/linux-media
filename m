Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38910 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbKWRvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 12:51:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Rafael =?ISO-8859-1?Q?Louren=E7o?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Joe Perches <joe@perches.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/18] [media] media-entity.h: rename entity.type to entity.function
Date: Mon, 23 Nov 2015 19:51:41 +0200
Message-ID: <7197567.LfPs5Bvqpi@avalon>
In-Reply-To: <10e7edf1c85965d8ef8c6c5f527fd695a2660fc4.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com> <10e7edf1c85965d8ef8c6c5f527fd695a2660fc4.1441559233.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 14:30:56 Mauro Carvalho Chehab wrote:
> Entities should have one or more functions. Calling it as a
> type proofed to not be correct, as an entity could eventually

s/proofed/proved/

> have more than one type.
> 
> So, rename the field as function.

s/as/to/

> Please notice that this patch doesn't extend support for
> multiple function entities. Such change will happen when
> we have real case drivers using it.
> 
> No functional changes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

[snip]

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 8bdc10dcc5e7..10f7d5f0eb66 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -152,7 +152,8 @@ struct media_entity_operations {
>   *
>   * @graph_obj:	Embedded structure containing the media object common data.
>   * @name:	Entity name.
> - * @type:	Entity type, as defined at uapi/media.h (MEDIA_ENT_T_*)
> + * @function:	Entity main function, as defined at uapi/media.h
> + *		(MEDIA_ENT_F_*)

I would squash this patch with "uapi/media.h: Rename entities types to 
functions" as they essentially touch the same lines. If you want to keep them 
separate I would use MEDIA_ENT_T_* here and rename it to MEDIA_ENT_F_* in 
"uapi/media.h: Rename entities types to functions".

>   * @revision:	Entity revision - OBSOLETE - should be removed soon.
>   * @flags:	Entity flags, as defined at uapi/media.h (MEDIA_ENT_FL_*)
>   * @group_id:	Entity group ID - OBSOLETE - should be removed soon.

[snip]

-- 
Regards,

Laurent Pinchart

