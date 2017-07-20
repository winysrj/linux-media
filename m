Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37652
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965348AbdGTOCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:02:23 -0400
Date: Thu, 20 Jul 2017 11:02:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 10/14] v4l: vsp1: Add support for multiple DRM
 pipelines
Message-ID: <20170720110210.7a8a84f0@vento.lan>
In-Reply-To: <20170626181226.29575-11-laurent.pinchart+renesas@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-11-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Jun 2017 21:12:22 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> The R-Car H3 ES2.0 VSP-DL instance has two LIF entities and can drive
> two display pipelines at the same time. Refactor the VSP DRM code to
> support that by introducing a vsp_drm_pipeline object that models one
> display pipeline.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
