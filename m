Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51781 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3GUGVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 02:21:19 -0400
Received: by mail-we0-f170.google.com with SMTP id w57so5090858wes.15
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 23:21:18 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 21 Jul 2013 11:50:57 +0530
Message-ID: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
Subject: Few Doubts on adding DT nodes for bridge driver
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester, Guennadi,

I am working on adding DT support for VPIF driver, initially to get
some hands dirty
on working on Capture driver and later will move ahead to add for the display.
I have added asynchronous probing support for the both the bridge and subdevs
which works perfectly like on a charm with passing pdata as usually,
but doing the
same with DT I have few doubts on building the pdata in the bridge driver.


This is a snippet of my subdes in i2c node:-

i2c0: i2c@1c22000 {
			status = "okay";
			clock-frequency = <100000>;
			pinctrl-names = "default";
			pinctrl-0 = <&i2c0_pins>;

			tvp514x@5c {
				compatible = "ti,tvp5146";
				reg = <0x5c>;

				port {
					tvp514x_1: endpoint {
						remote-endpoint = <&vpif_capture0_1>;
						hsync-active = <1>;
						vsync-active = <1>;
						pclk-sample = <0>;
					};
				};
			};

			tvp514x@5d {
				compatible = "ti,tvp5146";
				reg = <0x5d>;

				port {
					tvp514x_2: endpoint {
						remote-endpoint = <&vpif_capture0_0>;
						hsync-active = <1>;
						vsync-active = <1>;
						pclk-sample = <0>;
					};
				};
			};
                 ......
		};

Here tvp514x are the subdevs the platform has two of them one at 0x5c and 0x5d,
so I have added two nodes for them.

Following is DT node for the bridge driver:-

	vpif_capture@0 {
		status = "okay";
		port {
			vpif_capture0_1: endpoint@1 {
				remote = <&tvp514x_1>;
			};
			vpif_capture0_0: endpoint@0 {
				remote = <&tvp514x_2>;
			};
		};
	};
I have added two endpoints for the bridge driver. In the bridge driver
to build the pdata from DT node,I do the following,

np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
The above will give the first endpoint ie, endpoint@1
>From here is it possible to get the tvp514x_1 endpoint node and the
parent of it?
so that I  build the asynchronous subdev list for the bridge driver.


+static struct v4l2_async_subdev tvp1_sd = {
+       .hw = {
+               .bus_type = V4L2_ASYNC_BUS_I2C,
+               .match.i2c = {
+                       .adapter_id = 1,
+                       .address = 0x5c,
+               },
+       },
+};

For building the asd subdev list in the bridge driver I can get the
address easily,
how do I get the adapter_id ? should this be a property subdev ? And also same
with bustype.

Regards,
--Prabhakar
