Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32990 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbeKNXOJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:14:09 -0500
Received: by mail-ed1-f68.google.com with SMTP id r27so10648250eda.0
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 05:10:56 -0800 (PST)
Subject: Re: [PATCH v2 30/30] rcar-csi2: expose the subdevice internal routing
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-31-niklas.soderlund+renesas@ragnatech.se>
From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Message-ID: <aae0c45f-4c22-d463-1f1f-36e368d96bc5@cogentembedded.com>
Date: Wed, 14 Nov 2018 16:10:37 +0300
MIME-Version: 1.0
In-Reply-To: <20181101233144.31507-31-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> +	for (i = 0; i < fd.num_entries; i++) {
> +		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
> +		int source_pad;
> +
> +		source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
> +		if (source_pad < 0) {
> +			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
> +				entry->bus.csi2.channel);
> +			return -ENOSPC;

Why -ENOSPC here?

AFAIU negative source_pad here means driver internal error (frame desc
returned from rcsi2_get_remote_frame_desc() is invalid).  Then I think
error return should be -EIO.

Nikita
