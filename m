Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38173 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbCMFoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 01:44:14 -0400
MIME-Version: 1.0
In-Reply-To: <1426205008-6160-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1426205008-6160-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1426205008-6160-2-git-send-email-laurent.pinchart@ideasonboard.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 13 Mar 2015 05:43:42 +0000
Message-ID: <CA+V-a8u4dkx-tbrcZS5j1kq7HH3Q13_0BVAMLw2QaF-FyMC-Bg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] v4l: mt9v032: Add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	=?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Fri, Mar 13, 2015 at 12:03 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Parse DT properties into a platform data structure when a DT node is
> available.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> ---
>
[snip]
> +static struct mt9v032_platform_data *
> +mt9v032_get_pdata(struct i2c_client *client)
> +{
> +       struct mt9v032_platform_data *pdata;
> +       struct v4l2_of_endpoint endpoint;
> +       struct device_node *np;
> +       struct property *prop;
> +
> +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +               return client->dev.platform_data;
> +
> +       np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +       if (!np)
> +               return NULL;
> +
> +       if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> +               goto done;
> +
with the above two statements it seems its based on older version of kernel.

Cheers,
--Prabhakar Lad
