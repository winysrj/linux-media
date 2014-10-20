Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48258 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752836AbaJTVov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 17:44:51 -0400
Date: Tue, 21 Oct 2014 00:44:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v2 1/4] Add a media device configuration file parser.
Message-ID: <20141020214415.GE15257@valkosipuli.retiisi.org.uk>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
 <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413557682-20535-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Oct 17, 2014 at 04:54:39PM +0200, Jacek Anaszewski wrote:
> This patch adds a parser for a media device configuration
> file. The parser expects the configuration file containing
> links end v4l2-controls definitions as described in the
> header file being added. The links describe connections
> between media entities and v4l2-controls define the target
> sub-devices for particular user controls related ioctl calls.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  lib/include/libv4l2-media-conf-parser.h |  148 +++++++++++
>  lib/libv4l2/libv4l2-media-conf-parser.c |  441 +++++++++++++++++++++++++++++++
>  2 files changed, 589 insertions(+)
>  create mode 100644 lib/include/libv4l2-media-conf-parser.h
>  create mode 100644 lib/libv4l2/libv4l2-media-conf-parser.c
> 
> diff --git a/lib/include/libv4l2-media-conf-parser.h b/lib/include/libv4l2-media-conf-parser.h
> new file mode 100644
> index 0000000..b2dba3a
> --- /dev/null
> +++ b/lib/include/libv4l2-media-conf-parser.h
> @@ -0,0 +1,148 @@
> +/*
> + * Parser of media device configuration file.
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *              http://www.samsung.com
> + *
> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * The configuration file has to comply with following format:
> + *
> + * Link description entry format:
> + *
> + * link {
> + * <TAB>source_entity: <entity_name><LF>
> + * <TAB>source_pad: <pad_id><LF>
> + * <TAB>sink_entity: <entity_name><LF>
> + * <TAB>sink_pad: <pad_id><LF>
> + * }

Could you use the existing libmediactl format? The parser exists as well.

As a matter of fact, I have a few patches to make it easier to user in a
library.

libmediactl appears to be located under utils/media-ctl. Perhaps it's be
better placed under lib. Cc Laurent.

> + * The V4L2 control group format:
> + *
> + * v4l2-controls {
> + * <TAB><control1_name>: <entity_name><LF>
> + * <TAB><control2_name>: <entity_name><LF>
> + * ...
> + * <TAB><controlN_name>: <entity_name><LF>
> + * }

I didn't know you were working on this.

I have a small library which does essentially the same. The implementation
is incomplete, that's why I hadn't posted it to the list. We could perhaps
discuss this a little bit tomorrow. When would you be available, in case you
are?

What would you think of using a little bit more condensed format for this,
similar to that of libmediactl?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
