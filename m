Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44101
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751201AbcLENQA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 08:16:00 -0500
Subject: Re: [PATCH v2] v4l: async: make v4l2 coexist with devicetree nodes in
 a dt overlay
To: Javi Merino <javi.merino@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <0b71cde6-143c-0fa3-30c3-22caf94e14ec@osg.samsung.com>
Date: Mon, 5 Dec 2016 10:13:38 -0300
MIME-Version: 1.0
In-Reply-To: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javi,

On 12/05/2016 07:09 AM, Javi Merino wrote:
> In asds configured with V4L2_ASYNC_MATCH_OF, the v4l2 subdev can be
> part of a devicetree overlay, for example:
> 
> &media_bridge {
> 	...
> 	my_port: port@0 {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		reg = <0>;
> 		ep: endpoint@0 {
> 			remote-endpoint = <&camera0>;
> 		};
> 	};
> };
> 
> / {
> 	fragment@0 {
> 		target = <&i2c0>;
> 		__overlay__ {
> 			my_cam {
> 				compatible = "foo,bar";
> 				port {
> 					camera0: endpoint {
> 						remote-endpoint = <&my_port>;
> 						...
> 					};
> 				};
> 			};
> 		};
> 	};
> };
> 
> Each time the overlay is applied, its of_node pointer will be
> different.  We are not interested in matching the pointer, what we
> want to match is that the path is the one we are expecting.  Change to
> use of_node_cmp() so that we continue matching after the overlay has
> been removed and reapplied.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Javi Merino <javi.merino@kernel.org>
> ---

I already reviewed v1 but you didn't carry the tag. So again:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
