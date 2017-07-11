Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36261 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdGKTJd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 15:09:33 -0400
Received: by mail-pg0-f49.google.com with SMTP id u62so641069pgb.3
        for <linux-media@vger.kernel.org>; Tue, 11 Jul 2017 12:09:32 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] [media] davinci: vpif_capture: get subdevs from DT when available
References: <20170711130838.wsz63nclcrtxnbsm@mwanda>
Date: Tue, 11 Jul 2017 12:09:31 -0700
In-Reply-To: <20170711130838.wsz63nclcrtxnbsm@mwanda> (Dan Carpenter's message
        of "Tue, 11 Jul 2017 16:08:38 +0300")
Message-ID: <7hfue2vlhw.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Hello Kevin Hilman,
>
> The patch 4a5f8ae50b66: "[media] davinci: vpif_capture: get subdevs
> from DT when available" from Jun 6, 2017, leads to the following
> static checker warning:
>
> 	drivers/media/platform/davinci/vpif_capture.c:1596 vpif_capture_get_pdata()
> 	error: potential NULL dereference 'pdata'.
>
> drivers/media/platform/davinci/vpif_capture.c
>   1576  
>   1577                  dev_dbg(&pdev->dev, "Remote device %s, %s found\n",
>   1578                          rem->name, rem->full_name);
>   1579                  sdinfo->name = rem->full_name;
>   1580  
>   1581                  pdata->asd[i] = devm_kzalloc(&pdev->dev,
>   1582                                               sizeof(struct v4l2_async_subdev),
>   1583                                               GFP_KERNEL);
>   1584                  if (!pdata->asd[i]) {
>   1585                          of_node_put(rem);
>   1586                          pdata = NULL;
>                                 ^^^^^^^^^^^^
> Set to NULL
>
>   1587                          goto done;
>   1588                  }
>   1589  
>   1590                  pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
>   1591                  pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
>   1592                  of_node_put(rem);
>   1593          }
>   1594  
>   1595  done:
>   1596          pdata->asd_sizes[0] = i;
>                 ^^^^^^^^^^^^^^^^
> Dereference.
>
>   1597          pdata->subdev_count = i;
>   1598          pdata->card_name = "DA850/OMAP-L138 Video Capture";
>   1599  
>   1600          return pdata;
>   1601  }
>

Thanks for the bug report.  Fix submitted:
https://patchwork.linuxtv.org/patch/42433/

Kevin
