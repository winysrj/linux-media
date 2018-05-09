Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47128 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932701AbeEIOWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 10:22:39 -0400
Date: Wed, 9 May 2018 17:22:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH] media: i2c: add SCCB helpers
Message-ID: <20180509142236.e4lsibhp7pu7cpms@valkosipuli.retiisi.org.uk>
References: <1524759212-10941-1-git-send-email-akinobu.mita@gmail.com>
 <20180509105719.bydr4rla23okvlbf@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509105719.bydr4rla23okvlbf@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 09, 2018 at 12:57:19PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Apr 27, 2018 at 01:13:32AM +0900, Akinobu Mita wrote:
> > diff --git a/drivers/media/i2c/sccb.c b/drivers/media/i2c/sccb.c
> > new file mode 100644
> > index 0000000..80a3fb7
> > --- /dev/null
> > +++ b/drivers/media/i2c/sccb.c
> > @@ -0,0 +1,35 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/i2c.h>
> > +
> > +int sccb_read_byte(struct i2c_client *client, u8 addr)
> > +{
> > +	int ret;
> > +	u8 val;
> > +
> > +	/* Issue two separated requests in order to avoid repeated start */
> > +
> > +	ret = i2c_master_send(client, &addr, 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = i2c_master_recv(client, &val, 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return val;
> > +}
> > +EXPORT_SYMBOL_GPL(sccb_read_byte);
> > +
> > +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data)
> > +{
> > +	int ret;
> > +	unsigned char msgbuf[] = { addr, data };
> > +
> > +	ret = i2c_master_send(client, msgbuf, 2);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(sccb_write_byte);
> > diff --git a/drivers/media/i2c/sccb.h b/drivers/media/i2c/sccb.h
> > new file mode 100644
> > index 0000000..68da0e9
> > --- /dev/null
> > +++ b/drivers/media/i2c/sccb.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * SCCB helper functions
> > + */
> > +
> > +#ifndef __SCCB_H__
> > +#define __SCCB_H__
> > +
> > +#include <linux/i2c.h>
> > +
> > +int sccb_read_byte(struct i2c_client *client, u8 addr);
> > +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data);
> > +
> > +#endif /* __SCCB_H__ */
> 
> The functions look very simple. Have you considered moving them into
> sccb.h as static inline?

I agree. (Considering my previous comment on the dependencies, this is a
better idea. No need for a module this small.)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
