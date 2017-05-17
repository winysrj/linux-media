Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753726AbdEQQgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 12:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <56c9c74fa9e2879aea9e008d54d8b8d7b450b8ae.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
 <56c9c74fa9e2879aea9e008d54d8b8d7b450b8ae.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 17 May 2017 11:36:24 -0500
Message-ID: <CAL_JsqLvXH3kKV-DxWuNrAYGh8=L8Mdg5zcm2RsHZTpmi_8g-g@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] of: base: Provide of_graph_get_port_parent()
To: Kieran Bingham <kbingham@kernel.org>
Cc: "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 17, 2017 at 10:03 AM, Kieran Bingham <kbingham@kernel.org> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> When handling endpoints, the v4l2 async framework needs to identify the
> parent device of a port endpoint.
>
> Adapt the existing of_graph_get_remote_port_parent() such that a caller
> can obtain the parent of a port without parsing the remote-endpoint
> first.

A similar patch is already applied as part of the ASoC graph card support.

Rob
