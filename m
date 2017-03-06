Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35274 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753041AbdCFPQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 10:16:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] v4l: vsp1: Implement partition algorithm restrictions
Date: Mon, 06 Mar 2017 17:16:58 +0200
Message-ID: <5537374.FMr42qi89O@avalon>
In-Reply-To: <87tw772apo.wl%kuninori.morimoto.gx@renesas.com>
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <87tw7dn3aj.wl%kuninori.morimoto.gx@renesas.com> <87tw772apo.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Monday 06 Mar 2017 06:17:47 Kuninori Morimoto wrote:
> Hi Laurent, Kieran
> 
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 640x480 in RGB24: fail
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 768x576 in RGB24: pass
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 1024x768 in RGB24: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 1280x960 in RGB24: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 1536x1152 in RGB24: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 2048x1536 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 640x480 - 640x480 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 640x480 - 1280x960 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 768x576 - 768x576 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 768x576 - 1536x1152 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 1024x768 - 1024x768 in RGB24: pass
> >>> Testing UDS-SRU scaling 768x576 - 1024x768 - 2048x1536 in RGB24: pass
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 640x480 in YUV444M: fail
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 768x576 in YUV444M: pass
> >>> Testing SRU-UDS scaling 768x576 - 768x576 - 1024x768 in YUV444M: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 1280x960 in YUV444M: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 1536x1152 in YUV444M: pass
> >>> Testing SRU-UDS scaling 768x576 - 1536x1152 - 2048x1536 in YUV444M:hangs
> >>> Testing UDS-SRU scaling 768x576 - 640x480 - 640x480 in YUV444M: pass
> >>> Testing UDS-SRU scaling 768x576 - 640x480 - 1280x960 in YUV444M: fail
> >>> Testing UDS-SRU scaling 768x576 - 768x576 - 768x576 in YUV444M: pass
> >>> Testing UDS-SRU scaling 768x576 - 768x576 - 1536x1152 in YUV444M: pass
> >>> Testing UDS-SRU scaling 768x576 - 1024x768 - 1024x768 in YUV444M: pass
> >>> Testing UDS-SRU scaling 768x576 - 1024x768 - 2048x1536 in YUV444M:hangs
> >> 
> >> (snip)
> >> 
> >>> However, from the above tests it looks like the hardware can live with
> >>> more relaxed restrictions than the ones implemented here. I haven't
> >>> tested all UDS scaling ratios, and certainly not under all memory bus
> >>> load conditions, I might thus be too optimistic. Morimoto-san, would it
> >>> be possible to get more information about this from the hardware team,
> >>> to check whether the above two restrictions need to be honoured, or
> >> whether they come from an older hardware version ?
> >> 
> >> I asked it to HW team.
> >> Please wait
> 
> I'm still waiting from HW team's response, but can you check
> "32.3.7 Image partition for VSPI processing" on v0.53 datasheet ?
> (v0.53 is for ES2.0, but this chapter should be same for ES1.x / ES2.0)
> You may / may not find something from here

That's very detailed, good job of the documentation writers ! Please thank 
them for me if you know who they are :-)

I'm sure we will find useful information there. Kieran, could you please have 
a look when you'll be back at the end of this week, and list the points that 
you think we don't address correctly yet ?

-- 
Regards,

Laurent Pinchart
