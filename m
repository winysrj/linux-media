Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbeGBGJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 02:09:20 -0400
Date: Mon, 2 Jul 2018 09:09:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Steve Longerbeam <slongerbeam@gmail.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 15/17] media: platform: Switch to
 v4l2_async_notifier_add_subdev
Message-ID: <20180702060907.xlghcxtsj5eepdxu@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530298220-5097-16-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Steve-Longerbeam/media-imx-Switch-to-subdev-notifiers/20180630-035625
base:   git://linuxtv.org/media_tree.git master

New smatch warnings:
drivers/media/platform/xilinx/xilinx-vipp.c:97 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'
drivers/media/platform/xilinx/xilinx-vipp.c:335 xvip_graph_notify_bound() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'

Old smatch warnings:
drivers/media/platform/xilinx/xilinx-vipp.c:106 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'struct fwnode_handle*'
drivers/media/platform/xilinx/xilinx-vipp.c:133 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'
drivers/media/platform/xilinx/xilinx-vipp.c:143 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'struct fwnode_handle*'

# https://github.com/0day-ci/linux/commit/86ede05d30b3cad4b07c2df915fc83b94d3327f1
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 86ede05d30b3cad4b07c2df915fc83b94d3327f1
vim +97 drivers/media/platform/xilinx/xilinx-vipp.c

df3305156 Laurent Pinchart      2013-05-15   70  
df3305156 Laurent Pinchart      2013-05-15   71  static int xvip_graph_build_one(struct xvip_composite_device *xdev,
df3305156 Laurent Pinchart      2013-05-15   72  				struct xvip_graph_entity *entity)
df3305156 Laurent Pinchart      2013-05-15   73  {
df3305156 Laurent Pinchart      2013-05-15   74  	u32 link_flags = MEDIA_LNK_FL_ENABLED;
df3305156 Laurent Pinchart      2013-05-15   75  	struct media_entity *local = entity->entity;
df3305156 Laurent Pinchart      2013-05-15   76  	struct media_entity *remote;
df3305156 Laurent Pinchart      2013-05-15   77  	struct media_pad *local_pad;
df3305156 Laurent Pinchart      2013-05-15   78  	struct media_pad *remote_pad;
df3305156 Laurent Pinchart      2013-05-15   79  	struct xvip_graph_entity *ent;
859969b38 Sakari Ailus          2016-08-26   80  	struct v4l2_fwnode_link link;
86ede05d3 Steve Longerbeam      2018-06-29   81  	struct fwnode_handle *ep = NULL;
df3305156 Laurent Pinchart      2013-05-15   82  	int ret = 0;
df3305156 Laurent Pinchart      2013-05-15   83  
df3305156 Laurent Pinchart      2013-05-15   84  	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
df3305156 Laurent Pinchart      2013-05-15   85  
df3305156 Laurent Pinchart      2013-05-15   86  	while (1) {
df3305156 Laurent Pinchart      2013-05-15   87  		/* Get the next endpoint and parse its link. */
86ede05d3 Steve Longerbeam      2018-06-29   88  		ep = fwnode_graph_get_next_endpoint(entity->asd.match.fwnode,
86ede05d3 Steve Longerbeam      2018-06-29   89  						    ep);
ef94711a0 Akinobu Mita          2017-10-12   90  		if (ep == NULL)
df3305156 Laurent Pinchart      2013-05-15   91  			break;
df3305156 Laurent Pinchart      2013-05-15   92  
68d9c47b1 Rob Herring           2017-07-21   93  		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
df3305156 Laurent Pinchart      2013-05-15   94  
86ede05d3 Steve Longerbeam      2018-06-29   95  		ret = v4l2_fwnode_parse_link(ep, &link);
df3305156 Laurent Pinchart      2013-05-15   96  		if (ret < 0) {
68d9c47b1 Rob Herring           2017-07-21  @97  			dev_err(xdev->dev, "failed to parse link for %pOF\n",
68d9c47b1 Rob Herring           2017-07-21   98  				ep);
df3305156 Laurent Pinchart      2013-05-15   99  			continue;
df3305156 Laurent Pinchart      2013-05-15  100  		}
df3305156 Laurent Pinchart      2013-05-15  101  
df3305156 Laurent Pinchart      2013-05-15  102  		/* Skip sink ports, they will be processed from the other end of
df3305156 Laurent Pinchart      2013-05-15  103  		 * the link.
df3305156 Laurent Pinchart      2013-05-15  104  		 */
df3305156 Laurent Pinchart      2013-05-15  105  		if (link.local_port >= local->num_pads) {
68d9c47b1 Rob Herring           2017-07-21  106  			dev_err(xdev->dev, "invalid port number %u for %pOF\n",
86ede05d3 Steve Longerbeam      2018-06-29  107  				link.local_port, link.local_node);
859969b38 Sakari Ailus          2016-08-26  108  			v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  109  			ret = -EINVAL;
df3305156 Laurent Pinchart      2013-05-15  110  			break;
df3305156 Laurent Pinchart      2013-05-15  111  		}
df3305156 Laurent Pinchart      2013-05-15  112  
df3305156 Laurent Pinchart      2013-05-15  113  		local_pad = &local->pads[link.local_port];
df3305156 Laurent Pinchart      2013-05-15  114  
df3305156 Laurent Pinchart      2013-05-15  115  		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
68d9c47b1 Rob Herring           2017-07-21  116  			dev_dbg(xdev->dev, "skipping sink port %pOF:%u\n",
86ede05d3 Steve Longerbeam      2018-06-29  117  				link.local_node, link.local_port);
859969b38 Sakari Ailus          2016-08-26  118  			v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  119  			continue;
df3305156 Laurent Pinchart      2013-05-15  120  		}
df3305156 Laurent Pinchart      2013-05-15  121  
df3305156 Laurent Pinchart      2013-05-15  122  		/* Skip DMA engines, they will be processed separately. */
859969b38 Sakari Ailus          2016-08-26  123  		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
68d9c47b1 Rob Herring           2017-07-21  124  			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
86ede05d3 Steve Longerbeam      2018-06-29  125  				link.local_node, link.local_port);
859969b38 Sakari Ailus          2016-08-26  126  			v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  127  			continue;
df3305156 Laurent Pinchart      2013-05-15  128  		}
df3305156 Laurent Pinchart      2013-05-15  129  
df3305156 Laurent Pinchart      2013-05-15  130  		/* Find the remote entity. */
86ede05d3 Steve Longerbeam      2018-06-29  131  		ent = xvip_graph_find_entity(xdev, link.remote_node);
df3305156 Laurent Pinchart      2013-05-15  132  		if (ent == NULL) {
68d9c47b1 Rob Herring           2017-07-21  133  			dev_err(xdev->dev, "no entity found for %pOF\n",
86ede05d3 Steve Longerbeam      2018-06-29  134  				link.remote_node);
859969b38 Sakari Ailus          2016-08-26  135  			v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  136  			ret = -ENODEV;
df3305156 Laurent Pinchart      2013-05-15  137  			break;
df3305156 Laurent Pinchart      2013-05-15  138  		}
df3305156 Laurent Pinchart      2013-05-15  139  
df3305156 Laurent Pinchart      2013-05-15  140  		remote = ent->entity;
df3305156 Laurent Pinchart      2013-05-15  141  
df3305156 Laurent Pinchart      2013-05-15  142  		if (link.remote_port >= remote->num_pads) {
68d9c47b1 Rob Herring           2017-07-21  143  			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
86ede05d3 Steve Longerbeam      2018-06-29  144  				link.remote_port, link.remote_node);
859969b38 Sakari Ailus          2016-08-26  145  			v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  146  			ret = -EINVAL;
df3305156 Laurent Pinchart      2013-05-15  147  			break;
df3305156 Laurent Pinchart      2013-05-15  148  		}
df3305156 Laurent Pinchart      2013-05-15  149  
df3305156 Laurent Pinchart      2013-05-15  150  		remote_pad = &remote->pads[link.remote_port];
df3305156 Laurent Pinchart      2013-05-15  151  
859969b38 Sakari Ailus          2016-08-26  152  		v4l2_fwnode_put_link(&link);
df3305156 Laurent Pinchart      2013-05-15  153  
df3305156 Laurent Pinchart      2013-05-15  154  		/* Create the media link. */
df3305156 Laurent Pinchart      2013-05-15  155  		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
df3305156 Laurent Pinchart      2013-05-15  156  			local->name, local_pad->index,
df3305156 Laurent Pinchart      2013-05-15  157  			remote->name, remote_pad->index);
df3305156 Laurent Pinchart      2013-05-15  158  
8df00a158 Mauro Carvalho Chehab 2015-08-07  159  		ret = media_create_pad_link(local, local_pad->index,
df3305156 Laurent Pinchart      2013-05-15  160  					       remote, remote_pad->index,
df3305156 Laurent Pinchart      2013-05-15  161  					       link_flags);
df3305156 Laurent Pinchart      2013-05-15  162  		if (ret < 0) {
df3305156 Laurent Pinchart      2013-05-15  163  			dev_err(xdev->dev,
df3305156 Laurent Pinchart      2013-05-15  164  				"failed to create %s:%u -> %s:%u link\n",
df3305156 Laurent Pinchart      2013-05-15  165  				local->name, local_pad->index,
df3305156 Laurent Pinchart      2013-05-15  166  				remote->name, remote_pad->index);
df3305156 Laurent Pinchart      2013-05-15  167  			break;
df3305156 Laurent Pinchart      2013-05-15  168  		}
df3305156 Laurent Pinchart      2013-05-15  169  	}
df3305156 Laurent Pinchart      2013-05-15  170  
86ede05d3 Steve Longerbeam      2018-06-29  171  	fwnode_handle_put(ep);
df3305156 Laurent Pinchart      2013-05-15  172  	return ret;
df3305156 Laurent Pinchart      2013-05-15  173  }
df3305156 Laurent Pinchart      2013-05-15  174  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
