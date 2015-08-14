Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47442 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752297AbbHNWPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 18:15:30 -0400
Date: Sat, 15 Aug 2015 01:15:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 5/6] media: use media_graph_obj inside pads
Message-ID: <20150814221529.GD28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
 <3c1310f15c5ca9ca7446f8e3d8c835b3d796f607.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1310f15c5ca9ca7446f8e3d8c835b3d796f607.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 14, 2015 at 11:56:42AM -0300, Mauro Carvalho Chehab wrote:
> @@ -448,6 +456,7 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
>   */
>  void media_device_unregister_entity(struct media_entity *entity)
>  {
> +	int i;

I'd declare temporary variables as last.

>  	struct media_device *mdev = entity->parent;
>  
>  	if (mdev == NULL)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
