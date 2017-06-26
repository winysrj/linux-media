Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50658 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751435AbdFZQbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 12:31:37 -0400
Date: Mon, 26 Jun 2017 19:31:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v1 2/6] [media] ov9650: add device tree support
Message-ID: <20170626163102.GQ12407@valkosipuli.retiisi.org.uk>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-3-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498143942-12682-3-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Jun 22, 2017 at 05:05:38PM +0200, Hugues Fruchet wrote:
> @@ -1545,15 +1577,22 @@ static int ov965x_remove(struct i2c_client *client)
>  }
>  
>  static const struct i2c_device_id ov965x_id[] = {
> -	{ "OV9650", 0 },
> -	{ "OV9652", 0 },
> +	{ "OV9650", 0x9650 },
> +	{ "OV9652", 0x9652 },

This change does not appear to match with the patch description nor it the
information is used. How about not changing it, unless there's a reason to?
The same for the data field of the of_device_id array below.

>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(i2c, ov965x_id);
>  
> +static const struct of_device_id ov965x_of_match[] = {
> +	{ .compatible = "ovti,ov9650", .data = (void *)0x9650 },
> +	{ .compatible = "ovti,ov9652", .data = (void *)0x9652 },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ov965x_of_match);
>  static struct i2c_driver ov965x_i2c_driver = {
>  	.driver = {
>  		.name	= DRIVER_NAME,
> +		.of_match_table = of_match_ptr(ov965x_of_match),
>  	},
>  	.probe		= ov965x_probe,
>  	.remove		= ov965x_remove,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
