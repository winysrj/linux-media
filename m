Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37633
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964918AbdGTOAt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:00:49 -0400
Date: Thu, 20 Jul 2017 11:00:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/14] v4l: vsp1: Add support for multiple LIF
 instances
Message-ID: <20170720110041.3a9e1ef9@vento.lan>
In-Reply-To: <1a43853e-d33e-f990-255f-47e77fcc7573@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-10-laurent.pinchart+renesas@ideasonboard.com>
        <1a43853e-d33e-f990-255f-47e77fcc7573@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 18:57:40 +0100
Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:

> Hi Laurent,
> 
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The VSP2-DL instance (present in the H3 ES2.0 and M3-N SoCs) has two LIF
> > instances. Adapt the driver infrastructure to support multiple LIFs.
> > Support for multiple display pipelines will be added separately.
> > 
> > The change to the entity routing table removes the ability to connect
> > the LIF output to the HGO or HGT histogram generators. This feature is
> > only available on Gen2 hardware, isn't supported by the rest of the
> > driver, and has no known use case, so this isn't an issue.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> This looks good.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Thanks,
Mauro
