Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46266 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755205AbeE2Ixk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:53:40 -0400
Date: Tue, 29 May 2018 10:53:21 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2] dt-bindings: media: rcar_vin: fix style for ports and
 endpoints
Message-ID: <20180529085321.pfuls5vlwdx5zqib@verge.net.au>
References: <20180528231704.13806-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180528231704.13806-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 01:17:04AM +0200, Niklas Söderlund wrote:
> The style for referring to ports and endpoint are wrong. Refer to them
> using lowercase and a unit address, port@x and endpoint@x.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

FWIW, there are some instances of = that aren't preceded by a space
in this file.

This message was brought to you by Whitespace Tuesdays.
