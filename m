Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47102 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590AbbHNVJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 17:09:28 -0400
Date: Sat, 15 Aug 2015 00:08:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v4 2/6] media: create a macro to get entity ID
Message-ID: <20150814210855.GA28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
 <89205b71de7a6edc3638eb14df8d0b0e4df32bc2.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89205b71de7a6edc3638eb14df8d0b0e4df32bc2.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 14, 2015 at 11:56:39AM -0300, Mauro Carvalho Chehab wrote:
...
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 8b21a4d920d9..478d5cd56be9 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -126,6 +126,8 @@ struct media_entity_graph {
>  	int top;
>  };
>  
> +#define entity_id(entity) ((entity)->id)
> +
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		struct media_pad *pads);
>  void media_entity_cleanup(struct media_entity *entity);

media-entity.h is a pretty widely included header file. Perhaps we should
think about the naming a bit.

All the other names in the header begin with media (or __media); I'd very
much prefer not changing that pattern.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
