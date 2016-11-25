Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38096 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbcKYAZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 19:25:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Prevent commencing pipelines before they are setup
Date: Fri, 25 Nov 2016 02:26:01 +0200
Message-ID: <1835906.9KsnRA2js0@avalon>
In-Reply-To: <ac4eeacc-4211-830b-8b70-2cc88d03f01c@ideasonboard.com>
References: <1478860318-14792-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <ac4eeacc-4211-830b-8b70-2cc88d03f01c@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday 23 Nov 2016 12:28:15 Kieran Bingham wrote:
> Just FYI,
> 
> Whilst this patch is functional on its own, it is likely to be
> superseded before it gets a chance to be integrated as I am currently
> reworking vsp1_video_start_streaming(), in particular the use of
> vsp1_video_setup_pipeline().
> 
> The re-work will of course also consider and tackle the issue repaired here.

OK, I'll ignore this patch then.

-- 
Regards,

Laurent Pinchart

