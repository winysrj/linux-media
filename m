Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37556
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934910AbdGTNuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:50:32 -0400
Date: Thu, 20 Jul 2017 10:50:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieranbingham@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 01/14] v4l: vsp1: Fill display list headers without
 holding dlm spinlock
Message-ID: <20170720105022.5f123ca0@vento.lan>
In-Reply-To: <a45e660b-b931-ba16-d861-901c307afb1c@gmail.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-2-laurent.pinchart+renesas@ideasonboard.com>
        <a45e660b-b931-ba16-d861-901c307afb1c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 13:48:40 +0100
Kieran Bingham <kieranbingham@gmail.com> escreveu:

> Hi Laurent,
> 
> Starts easy ... (I haven't gone through these in numerical order of course :D)
> 
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The display list headers are filled using information from the display
> > list only. Lower the display list manager spinlock contention by filling
> > the headers without holding the lock.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
