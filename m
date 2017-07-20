Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37572
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755406AbdGTNxT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:53:19 -0400
Date: Thu, 20 Jul 2017 10:53:11 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 04/14] v4l: vsp1: Store source and sink pointers as
 vsp1_entity
Message-ID: <20170720105311.147b2308@vento.lan>
In-Reply-To: <7dbc0bcd-bc72-b45c-0fcd-56b0780880a9@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-5-laurent.pinchart+renesas@ideasonboard.com>
        <7dbc0bcd-bc72-b45c-0fcd-56b0780880a9@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 14:00:31 +0100
Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> escreveu:

> Hi Laurent,
> 
> This looks like a good simplification/removal of obfuscation to me!
> 
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The internal VSP entity source and sink pointers are stored as
> > media_entity pointers, which are then cast to a vsp1_entity. As all
> > sources and sinks are vsp1_entity instances, we can store the
> > vsp1_entity pointers directly.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
