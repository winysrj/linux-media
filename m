Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54160 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933989AbdERNSg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:18:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Rob Herring <robh+dt@kernel.org>,
        Kieran Bingham <kbingham@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] of: base: Provide of_graph_get_port_parent()
Date: Thu, 18 May 2017 16:18:39 +0300
Message-ID: <2172554.nJqIiczhoI@avalon>
In-Reply-To: <61138419-5781-bbec-7ac5-44524ad501ce@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com> <CAL_JsqLvXH3kKV-DxWuNrAYGh8=L8Mdg5zcm2RsHZTpmi_8g-g@mail.gmail.com> <61138419-5781-bbec-7ac5-44524ad501ce@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday 17 May 2017 21:02:42 Kieran Bingham wrote:
> On 17/05/17 17:36, Rob Herring wrote:
> > On Wed, May 17, 2017 at 10:03 AM, Kieran Bingham wrote:
> >> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> 
> >> When handling endpoints, the v4l2 async framework needs to identify the
> >> parent device of a port endpoint.
> >> 
> >> Adapt the existing of_graph_get_remote_port_parent() such that a caller
> >> can obtain the parent of a port without parsing the remote-endpoint
> >> first.
> > 
> > A similar patch is already applied as part of the ASoC graph card support.
> > 
> > Rob
> 
> Ah yes, a quick google finds it...
> 
> :  https://patchwork.kernel.org/patch/9658907/
> 
> Surprisingly similar patch ... and a familiar name.

Very similar indeed, down to identical problems ;-) Quoting your patch,

>  /**
> + * of_graph_get_port_parent() - get port's parent node
> + * @node: pointer to a local endpoint device_node
> + *
> + * Return: device node associated with endpoint @node.
> + *	   Use of_node_put() on it when done.
> + */

The documentation of the return value is a bit confusing to me. I assume that, 
by device node, you meant the DT node corresponding to the device of the 
endpoint which is passed as an argument. However, device node cal also refer 
to struct device_node. Should this be clarified ?

> Morimoto-san - you beat me to it :D !
> 
> Thanks Rob, (And Morimoto!)

-- 
Regards,

Laurent Pinchart
