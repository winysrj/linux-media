Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33000 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbcLFJJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 04:09:25 -0500
Date: Tue, 6 Dec 2016 09:08:51 +0000
From: Javi Merino <javi.merino@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2] v4l: async: make v4l2 coexist with devicetree nodes
 in a dt overlay
Message-ID: <20161206090851.GA1704@ct-lt-587>
References: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
 <0b71cde6-143c-0fa3-30c3-22caf94e14ec@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0b71cde6-143c-0fa3-30c3-22caf94e14ec@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 05, 2016 at 10:13:38AM -0300, Javier Martinez Canillas wrote:
> Hello Javi,
> 
> On 12/05/2016 07:09 AM, Javi Merino wrote:
> > In asds configured with V4L2_ASYNC_MATCH_OF, the v4l2 subdev can be
> > part of a devicetree overlay, for example:
> > 
> > &media_bridge {
> > 	...
> > 	my_port: port@0 {
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 		reg = <0>;
> > 		ep: endpoint@0 {
> > 			remote-endpoint = <&camera0>;
> > 		};
> > 	};
> > };
> > 
> > / {
> > 	fragment@0 {
> > 		target = <&i2c0>;
> > 		__overlay__ {
> > 			my_cam {
> > 				compatible = "foo,bar";
> > 				port {
> > 					camera0: endpoint {
> > 						remote-endpoint = <&my_port>;
> > 						...
> > 					};
> > 				};
> > 			};
> > 		};
> > 	};
> > };
> > 
> > Each time the overlay is applied, its of_node pointer will be
> > different.  We are not interested in matching the pointer, what we
> > want to match is that the path is the one we are expecting.  Change to
> > use of_node_cmp() so that we continue matching after the overlay has
> > been removed and reapplied.
> > 
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Javi Merino <javi.merino@kernel.org>
> > ---
> 
> I already reviewed v1 but you didn't carry the tag. So again:

I forgot to add it :(

> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Thanks!
Javi
