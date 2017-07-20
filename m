Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37605
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965220AbdGTN6P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:58:15 -0400
Date: Thu, 20 Jul 2017 10:58:07 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 07/14] v4l: vsp1: Add support for the BRS entity
Message-ID: <20170720105807.4b24e04c@vento.lan>
In-Reply-To: <a89a37a8-ec11-cd50-5323-48510c11bcce@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-8-laurent.pinchart+renesas@ideasonboard.com>
        <a89a37a8-ec11-cd50-5323-48510c11bcce@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 14:38:40 +0100
Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> escreveu:

> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The Blend/ROP Sub Unit (BRS) is a stripped-down version of the BRU found
> > in several VSP2 instances. Compared to a regular BRU, it supports two
> > inputs only, and thus has no ROP unit.
> > 
> > Add support for the BRS by modeling it as a new entity type, but reuse  
> 
> s/modeling/modelling/
> 
> 
> > the vsp1_bru object underneath. Chaining the BRU and BRS entities seems
> > to be supported by the hardware but isn't implemented yet as it isn't
> > the primary use case for the BRS.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
