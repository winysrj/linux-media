Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37567
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965097AbdGTNwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:52:23 -0400
Date: Thu, 20 Jul 2017 10:52:14 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 03/14] v4l: vsp1: Don't set WPF sink pointer
Message-ID: <20170720105214.5cd1a014@vento.lan>
In-Reply-To: <61e7fb65-9f7a-7f36-12dd-02fd709cec52@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-4-laurent.pinchart+renesas@ideasonboard.com>
        <61e7fb65-9f7a-7f36-12dd-02fd709cec52@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 13:50:20 +0100
Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> escreveu:

> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The sink pointer is used to configure routing inside the VSP, and as
> > such must point to the next VSP entity in the pipeline. The WPF being a
> > pipeline terminal sink, its output route can't be configured. The
> > routing configuration code already handles this correctly without
> > referring to the sink pointer, which thus doesn't need to be set.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Thanks,
Mauro
