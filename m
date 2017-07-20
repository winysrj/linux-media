Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37617
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965225AbdGTN7d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:59:33 -0400
Date: Thu, 20 Jul 2017 10:59:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2.1 08/14] v4l: vsp1: Add support for new VSP2-BS,
 VSP2-DL and VSP2-D instances
Message-ID: <20170720105924.0cea6cfa@vento.lan>
In-Reply-To: <20170714003557.4057-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170626181226.29575-9-laurent.pinchart+renesas@ideasonboard.com>
        <20170714003557.4057-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Jul 2017 03:35:57 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> New Gen3 SoCs come with two new VSP2 variants names VSP2-BS and VSP2-DL,
> as well as a new VSP2-D variant on V3M and V3H SoCs. Add new entries for
> them in the VSP device info table.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
