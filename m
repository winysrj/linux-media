Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24687 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdGKNIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 09:08:50 -0400
Date: Tue, 11 Jul 2017 16:08:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: khilman@baylibre.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] davinci: vpif_capture: get subdevs from DT when
 available
Message-ID: <20170711130838.wsz63nclcrtxnbsm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kevin Hilman,

The patch 4a5f8ae50b66: "[media] davinci: vpif_capture: get subdevs
from DT when available" from Jun 6, 2017, leads to the following
static checker warning:

	drivers/media/platform/davinci/vpif_capture.c:1596 vpif_capture_get_pdata()
	error: potential NULL dereference 'pdata'.

drivers/media/platform/davinci/vpif_capture.c
  1576  
  1577                  dev_dbg(&pdev->dev, "Remote device %s, %s found\n",
  1578                          rem->name, rem->full_name);
  1579                  sdinfo->name = rem->full_name;
  1580  
  1581                  pdata->asd[i] = devm_kzalloc(&pdev->dev,
  1582                                               sizeof(struct v4l2_async_subdev),
  1583                                               GFP_KERNEL);
  1584                  if (!pdata->asd[i]) {
  1585                          of_node_put(rem);
  1586                          pdata = NULL;
                                ^^^^^^^^^^^^
Set to NULL

  1587                          goto done;
  1588                  }
  1589  
  1590                  pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
  1591                  pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
  1592                  of_node_put(rem);
  1593          }
  1594  
  1595  done:
  1596          pdata->asd_sizes[0] = i;
                ^^^^^^^^^^^^^^^^
Dereference.

  1597          pdata->subdev_count = i;
  1598          pdata->card_name = "DA850/OMAP-L138 Video Capture";
  1599  
  1600          return pdata;
  1601  }

regards,
dan carpenter
