Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57721 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbeB0JNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 04:13:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH 02/15] v4l: vsp1: Remove outdated comment
Date: Tue, 27 Feb 2018 11:14:02 +0200
Message-ID: <1818947.grirGFg99K@avalon>
In-Reply-To: <81dab538-1697-7cd5-7df2-d5e4c6fae217@cogentembedded.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com> <20180226214516.11559-3-laurent.pinchart+renesas@ideasonboard.com> <81dab538-1697-7cd5-7df2-d5e4c6fae217@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Tuesday, 27 February 2018 10:22:25 EET Sergei Shtylyov wrote:
> On 2/27/2018 12:45 AM, Laurent Pinchart wrote:
> > The entities in the pipeline are all started when the LIF is setup.
> > Remove the outdated comment that state otherwise.
> 
> States?

You're right, will fix in v2.

> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
