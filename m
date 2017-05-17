Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:11891 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752375AbdEQXxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 19:53:13 -0400
Message-ID: <87lgpvoxja.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To: <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Kieran Bingham <kbingham@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] of: base: Provide of_graph_get_port_parent()
In-Reply-To: <61138419-5781-bbec-7ac5-44524ad501ce@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
        <56c9c74fa9e2879aea9e008d54d8b8d7b450b8ae.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
        <CAL_JsqLvXH3kKV-DxWuNrAYGh8=L8Mdg5zcm2RsHZTpmi_8g-g@mail.gmail.com>
        <61138419-5781-bbec-7ac5-44524ad501ce@ideasonboard.com>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset="US-ASCII"
Date: Wed, 17 May 2017 23:53:00 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Kieran

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
> :  https://patchwork.kernel.org/patch/9658907/
> 
> Surprisingly similar patch ... and a familiar name.
> 
> Morimoto-san - you beat me to it :D !

Interesting.
It was applies today to Mark's (= ALSA SoC Maintainer) branch !
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git/commit/?h=topic/of-graph&id=0ef472a973ebbfc20f2f12769e77a8cfd3612778


Best regards
---
Kuninori Morimoto
