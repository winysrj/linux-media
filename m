Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37661
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965347AbdGTODP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:03:15 -0400
Date: Thu, 20 Jul 2017 11:03:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 11/14] v4l: vsp1: Add support for header display
 lists in continuous mode
Message-ID: <20170720110308.7572b061@vento.lan>
In-Reply-To: <20170626181226.29575-12-laurent.pinchart+renesas@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-12-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Jun 2017 21:12:23 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> The VSP supports both header and headerless display lists. The latter is
> easier to use when the VSP feeds data directly to the DU in continuous
> mode, and the driver thus uses headerless display lists for DU operation
> and header display lists otherwise.
> 
> Headerless display lists are only available on WPF.0. This has never
> been an issue so far, as only WPF.0 is connected to the DU. However, on
> H3 ES2.0, the VSP-DL instance has both WPF.0 and WPF.1 connected to the
> DU. We thus can't use headerless display lists unconditionally for DU
> operation.
> 
> Implement support for continuous mode with header display lists, and use
> it for DU operation on WPF outputs that don't support headerless mode.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
