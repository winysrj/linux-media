Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36850 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754302AbeGGVHD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 17:07:03 -0400
Subject: Re: [PATCH v5 15/17] media: platform: Switch to
 v4l2_async_notifier_add_subdev
To: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180702060907.xlghcxtsj5eepdxu@mwanda>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <eb8fbaae-6ab3-e1fa-9575-fbadb8d55342@gmail.com>
Date: Sat, 7 Jul 2018 14:06:59 -0700
MIME-Version: 1.0
In-Reply-To: <20180702060907.xlghcxtsj5eepdxu@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/01/2018 11:09 PM, Dan Carpenter wrote:
> Hi Steve,
>
> I love your patch! Perhaps something to improve:
>
> url:    https://github.com/0day-ci/linux/commits/Steve-Longerbeam/media-imx-Switch-to-subdev-notifiers/20180630-035625
> base:   git://linuxtv.org/media_tree.git master
>
> New smatch warnings:
> drivers/media/platform/xilinx/xilinx-vipp.c:97 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'
> drivers/media/platform/xilinx/xilinx-vipp.c:335 xvip_graph_notify_bound() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'
>
> Old smatch warnings:
> drivers/media/platform/xilinx/xilinx-vipp.c:106 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'struct fwnode_handle*'
> drivers/media/platform/xilinx/xilinx-vipp.c:133 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'struct fwnode_handle*'
> drivers/media/platform/xilinx/xilinx-vipp.c:143 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'struct fwnode_handle*'

Thanks for the report. Will fix for v8.

Steve
