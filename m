Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51108 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdEQUCr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 16:02:47 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v1 1/3] of: base: Provide of_graph_get_port_parent()
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
 <56c9c74fa9e2879aea9e008d54d8b8d7b450b8ae.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
 <CAL_JsqLvXH3kKV-DxWuNrAYGh8=L8Mdg5zcm2RsHZTpmi_8g-g@mail.gmail.com>
To: Rob Herring <robh+dt@kernel.org>,
        Kieran Bingham <kbingham@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <61138419-5781-bbec-7ac5-44524ad501ce@ideasonboard.com>
Date: Wed, 17 May 2017 21:02:42 +0100
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLvXH3kKV-DxWuNrAYGh8=L8Mdg5zcm2RsHZTpmi_8g-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/05/17 17:36, Rob Herring wrote:
> On Wed, May 17, 2017 at 10:03 AM, Kieran Bingham <kbingham@kernel.org> wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> When handling endpoints, the v4l2 async framework needs to identify the
>> parent device of a port endpoint.
>>
>> Adapt the existing of_graph_get_remote_port_parent() such that a caller
>> can obtain the parent of a port without parsing the remote-endpoint
>> first.
> 
> A similar patch is already applied as part of the ASoC graph card support.
> 
> Rob

Ah yes, a quick google finds it...
:  https://patchwork.kernel.org/patch/9658907/

Surprisingly similar patch ... and a familiar name.

Morimoto-san - you beat me to it :D !

Thanks Rob, (And Morimoto!)

--
Kieran
