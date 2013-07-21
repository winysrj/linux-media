Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41602 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3GUJYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 05:24:19 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so2163070bkc.28
        for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 02:24:18 -0700 (PDT)
Message-ID: <51EBA8BF.7030303@gmail.com>
Date: Sun, 21 Jul 2013 11:24:15 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Few Doubts on adding DT nodes for bridge driver
References: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
In-Reply-To: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 07/21/2013 08:20 AM, Prabhakar Lad wrote:
> Hi Sylwester, Guennadi,
>
> I am working on adding DT support for VPIF driver, initially to get
> some hands dirty
> on working on Capture driver and later will move ahead to add for the display.
> I have added asynchronous probing support for the both the bridge and subdevs
> which works perfectly like on a charm with passing pdata as usually,
> but doing the
> same with DT I have few doubts on building the pdata in the bridge driver.
>
>
> This is a snippet of my subdes in i2c node:-
>
> i2c0: i2c@1c22000 {
> 			status = "okay";
> 			clock-frequency =<100000>;
> 			pinctrl-names = "default";
> 			pinctrl-0 =<&i2c0_pins>;
>
> 			tvp514x@5c {
> 				compatible = "ti,tvp5146";
> 				reg =<0x5c>;
>
> 				port {
> 					tvp514x_1: endpoint {
> 						remote-endpoint =<&vpif_capture0_1>;
> 						hsync-active =<1>;
> 						vsync-active =<1>;
> 						pclk-sample =<0>;
> 					};
> 				};
> 			};
>
> 			tvp514x@5d {
> 				compatible = "ti,tvp5146";
> 				reg =<0x5d>;
>
> 				port {
> 					tvp514x_2: endpoint {
> 						remote-endpoint =<&vpif_capture0_0>;
> 						hsync-active =<1>;
> 						vsync-active =<1>;
> 						pclk-sample =<0>;
> 					};
> 				};
> 			};
>                   ......
> 		};
>
> Here tvp514x are the subdevs the platform has two of them one at 0x5c and 0x5d,
> so I have added two nodes for them.
>
> Following is DT node for the bridge driver:-
>
> 	vpif_capture@0 {
> 		status = "okay";
> 		port {

You should also have:
			#address-cells = <1>;
			#size-cells = <0>;

here or in vpif_capture node.

> 			vpif_capture0_1: endpoint@1 {
> 				remote =<&tvp514x_1>;
> 			};
> 			vpif_capture0_0: endpoint@0 {
> 				remote =<&tvp514x_2>;
> 			};
> 		};
> 	};

Are tvp514x@5c and tvp514x@5d decoders really connected to same bus, or are
they on separate busses ? If the latter then you should have 2 'port' 
nodes.
And in such case don't you need to identify to which

> I have added two endpoints for the bridge driver. In the bridge driver
> to build the pdata from DT node,I do the following,
>
> np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
>
> The above will give the first endpoint ie, endpoint@1
>  From here is it possible to get the tvp514x_1 endpoint node and the
> parent of it?

Isn't v4l2_of_get_remote_port_parent() what you need ?

> so that I  build the asynchronous subdev list for the bridge driver.
>
>
> +static struct v4l2_async_subdev tvp1_sd = {
> +       .hw = {

This doesn't match the current struct v4l2_async_subdev data strcucture,
there is no 'hw' field now.

> +               .bus_type = V4L2_ASYNC_BUS_I2C,
> +               .match.i2c = {
> +                       .adapter_id = 1,
> +                       .address = 0x5c,
> +               },
> +       },
> +};
>
> For building the asd subdev list in the bridge driver I can get the
> address easily,
> how do I get the adapter_id ? should this be a property subdev ? And also same
> with bustype.

I had been working on the async subdev registration support in the 
exynos4-is
driver this week and I have a few patches for v4l2-async.
What those patches do is renaming V4L2_ASYNC_BUS_* to V4L2_ASYNC_MATCH_*,
adding V4L2_ASYNC_MATCH_OF and a corresponding match_of callback like:

static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
{
	return dev->of_node == asd->match.of.node;
}

Then a driver registering the notifier, after parsing the device tree, can
just pass a list of DT node pointers corresponding to its subdevs.

All this could also be achieved with V4L2_ASYNC_BUS_CUSTOM, but I think it's
better to make it as simple as possible for drivers by extending the core
a little.

I'm going to post those patches as RFC on Monday.

--
Regards,
Sylwester
