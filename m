Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41819 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbCNA0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 20:26:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] v4l: mt9v032: Add OF support
Date: Sat, 14 Mar 2015 02:26:38 +0200
Message-ID: <7629490.JGcFgSER1P@avalon>
In-Reply-To: <CA+V-a8u4dkx-tbrcZS5j1kq7HH3Q13_0BVAMLw2QaF-FyMC-Bg@mail.gmail.com>
References: <1426205008-6160-1-git-send-email-laurent.pinchart@ideasonboard.com> <1426205008-6160-2-git-send-email-laurent.pinchart@ideasonboard.com> <CA+V-a8u4dkx-tbrcZS5j1kq7HH3Q13_0BVAMLw2QaF-FyMC-Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Friday 13 March 2015 05:43:42 Lad, Prabhakar wrote:
> On Fri, Mar 13, 2015 at 12:03 AM, Laurent Pinchart wrote:
> > Parse DT properties into a platform data structure when a DT node is
> > available.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > ---
> 
> [snip]
> 
> > +static struct mt9v032_platform_data *
> > +mt9v032_get_pdata(struct i2c_client *client)
> > +{
> > +       struct mt9v032_platform_data *pdata;
> > +       struct v4l2_of_endpoint endpoint;
> > +       struct device_node *np;
> > +       struct property *prop;
> > +
> > +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> > +               return client->dev.platform_data;
> > +
> > +       np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> > +       if (!np)
> > +               return NULL;
> > +
> > +       if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> > +               goto done;
> > +
> 
> with the above two statements it seems its based on older version of kernel.

You're absolutely right, I've sent the wrong version of the patch, sorry about 
that.

I'll fix the v4l2_of_get_next_endpoint() call in v3. Is there anything wrong 
with v4l2_of_parse_endpoint() though ?

-- 
Regards,

Laurent Pinchart

