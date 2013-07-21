Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GUJrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 05:47:03 -0400
Date: Sun, 21 Jul 2013 11:47:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Few Doubts on adding DT nodes for bridge driver
In-Reply-To: <51EBA8BF.7030303@gmail.com>
Message-ID: <Pine.LNX.4.64.1307211144440.10557@axis700.grange>
References: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
 <51EBA8BF.7030303@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 21 Jul 2013, Sylwester Nawrocki wrote:

> Hi Prabhakar,
> 
> On 07/21/2013 08:20 AM, Prabhakar Lad wrote:
> > Hi Sylwester, Guennadi,
> > 
> > I am working on adding DT support for VPIF driver, initially to get
> > some hands dirty
> > on working on Capture driver and later will move ahead to add for the
> > display.
> > I have added asynchronous probing support for the both the bridge and
> > subdevs
> > which works perfectly like on a charm with passing pdata as usually,
> > but doing the
> > same with DT I have few doubts on building the pdata in the bridge driver.
> > 
> > 
> > This is a snippet of my subdes in i2c node:-
> > 
> > i2c0: i2c@1c22000 {
> > 			status = "okay";
> > 			clock-frequency =<100000>;
> > 			pinctrl-names = "default";
> > 			pinctrl-0 =<&i2c0_pins>;
> > 
> > 			tvp514x@5c {
> > 				compatible = "ti,tvp5146";
> > 				reg =<0x5c>;
> > 
> > 				port {
> > 					tvp514x_1: endpoint {
> > 						remote-endpoint
> > =<&vpif_capture0_1>;
> > 						hsync-active =<1>;
> > 						vsync-active =<1>;
> > 						pclk-sample =<0>;
> > 					};
> > 				};
> > 			};
> > 
> > 			tvp514x@5d {
> > 				compatible = "ti,tvp5146";
> > 				reg =<0x5d>;
> > 
> > 				port {
> > 					tvp514x_2: endpoint {
> > 						remote-endpoint
> > =<&vpif_capture0_0>;
> > 						hsync-active =<1>;
> > 						vsync-active =<1>;
> > 						pclk-sample =<0>;
> > 					};
> > 				};
> > 			};
> >                   ......
> > 		};
> > 
> > Here tvp514x are the subdevs the platform has two of them one at 0x5c and
> > 0x5d,
> > so I have added two nodes for them.
> > 
> > Following is DT node for the bridge driver:-
> > 
> > 	vpif_capture@0 {
> > 		status = "okay";
> > 		port {
> 
> You should also have:
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> here or in vpif_capture node.
> 
> > 			vpif_capture0_1: endpoint@1 {
> > 				remote =<&tvp514x_1>;
> > 			};
> > 			vpif_capture0_0: endpoint@0 {
> > 				remote =<&tvp514x_2>;

BTW, just occurred to me: shouldn't also these rather be 
"remote-endpoint?" The documentation example should then be fixed too.

> > 			};
> > 		};
> > 	};
> 
> Are tvp514x@5c and tvp514x@5d decoders really connected to same bus, or are
> they on separate busses ? If the latter then you should have 2 'port' nodes.
> And in such case don't you need to identify to which
> 
> > I have added two endpoints for the bridge driver. In the bridge driver
> > to build the pdata from DT node,I do the following,
> > 
> > np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
> > 
> > The above will give the first endpoint ie, endpoint@1
> >  From here is it possible to get the tvp514x_1 endpoint node and the
> > parent of it?
> 
> Isn't v4l2_of_get_remote_port_parent() what you need ?

Right, forgot we've got a helper for that already.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
