Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58852 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaCaL1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 07:27:48 -0400
Received: by mail-lb0-f169.google.com with SMTP id q8so5816558lbi.28
        for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 04:27:47 -0700 (PDT)
Message-ID: <53395131.6090002@cogentembedded.com>
Date: Mon, 31 Mar 2014 15:27:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Subject: Re: [RFC 2/3] rcar_vin: add devicetree support
References: <1396214765-23689-1-git-send-email-ben.dooks@codethink.co.uk> <1396214765-23689-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1396214765-23689-2-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 31-03-2014 1:26, Ben Dooks wrote:

> Add support for devicetree probe for the rcar-vin
> driver.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>   .../devicetree/bindings/media/rcar_vin.txt         | 79 ++++++++++++++++++++++
>   drivers/media/platform/soc_camera/rcar_vin.c       | 67 ++++++++++++++++--
>   2 files changed, 140 insertions(+), 6 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt

> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> new file mode 100644
> index 0000000..105b8de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -0,0 +1,79 @@
> +Renesas RCar Video Input driver (rcar_vin)
> +------------------------------------------
> +
> +The rcar_vin device provides video input capabilities for the Renesas R-Car
> +family of devices. The current blocks are always slaves and suppot one input
> +channel which can be either RGB, YUYV or BT656.
> +
> + - compatible: Must be one of the following
> +   - "renesas,vin-r8a7791" for the R8A7791 device
> +   - "renesas,vin-r8a7790" for the R8A7790 device
> +   - "renesas,vin-r8a7779" for the R8A7779 device
> +   - "renesas,vin-r8a7778" for the R8A7778 device
> + - reg: the register base and size for the device registers

    Register base of the registers?

[...]
> +/* composite video input */
> +&vin1 {
> +        pinctrl-0 = <&vin1_pins>;
> +        pinctrl-names = "default";
> +
> +        status = "ok";
> +
> +        port {
> +                #address-cells = <1>;

    Where is this used? I don't see "reg" prop in the sub-node...

> +                #size-cells = <0>;
> +
> +                vin1ep0: endpoint {
> +                        remote-endpoint = <&adv7180_1>;
> +                        bus-width = <8>;
> +                };
> +        };
> +};
> +
> +
> +
> +[1] video-interfaces.txt common video media interface
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 47516df..73c56c7 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -1392,6 +1395,17 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>   	.init_videobuf2	= rcar_vin_init_videobuf2,
>   };
>
> +#ifdef CONFIG_OF

    I don't think it's worth using this #ifdef -- the OF code is not under 
#ifdef anyway...

> +static struct of_device_id rcar_vin_of_table[] = {
> +	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> +	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
> +#endif
> +
>   static struct platform_device_id rcar_vin_id_table[] = {
>   	{ "r8a7791-vin",  RCAR_GEN2 },
>   	{ "r8a7790-vin",  RCAR_GEN2 },
> @@ -1404,15 +1418,50 @@ MODULE_DEVICE_TABLE(platform, rcar_vin_id_table);
>
>   static int rcar_vin_probe(struct platform_device *pdev)
>   {
> +	const struct of_device_id *match = NULL;
>   	struct rcar_vin_priv *priv;
>   	struct resource *mem;
>   	struct rcar_vin_platform_data *pdata;
> +	unsigned int pdata_flags;
>   	int irq, ret;
>
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata || !pdata->flags) {
> -		dev_err(&pdev->dev, "platform data not set\n");
> -		return -EINVAL;
> +	if (pdev->dev.of_node) {
> +		struct v4l2_of_endpoint ep;
> +		struct device_node *np;
> +
> +		match = of_match_device(of_match_ptr(rcar_vin_of_table),
> +					&pdev->dev);
> +
> +		np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
> +		if (!np) {
> +			dev_err(&pdev->dev, "could not find endpoint\n");
> +			return -EINVAL;
> +		}
> +
> +		ret = v4l2_of_parse_endpoint(np, &ep);
> +		if (ret) {
> +			dev_err(&pdev->dev, "could not parse endpoint\n");
> +			return ret;
> +		}
> +
> +		if (ep.bus_type == V4L2_MBUS_BT656)
> +			pdata_flags = RCAR_VIN_BT656;
> +		else {

    Need {} in all arms of this *if* statement.

[...]
> @@ -1447,8 +1496,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
>   	priv->ici.drv_name = dev_name(&pdev->dev);
>   	priv->ici.ops = &rcar_vin_host_ops;
>
> -	priv->pdata_flags = pdata->flags;
> -	priv->chip = pdev->id_entry->driver_data;
> +	priv->pdata_flags = pdata_flags;
> +	if (!match)
> +		priv->chip = pdev->id_entry->driver_data;
> +	else
> +		priv->chip = (enum chip_id)match->data;
> +
> +

    Too many empty lines.

> @@ -1489,6 +1543,7 @@ static struct platform_driver rcar_vin_driver = {
>   	.driver		= {
>   		.name		= DRV_NAME,
>   		.owner		= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(rcar_vin_of_table),

    Don't think we need of_match_ptr() as well as #ifdef CONFIG_OF.

[...]

WBR, Sergei

