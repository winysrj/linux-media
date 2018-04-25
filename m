Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38758 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbeDYK2X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 06:28:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
Date: Wed, 25 Apr 2018 13:28:37 +0300
Message-ID: <4069198.SojKMEipNL@avalon>
In-Reply-To: <7644bb92-e7b2-db27-061b-e0808c7264cd@ti.com>
References: <cover.1524245455.git.mchehab@s-opensource.com> <10529104.rM2F4eJv5O@avalon> <7644bb92-e7b2-db27-061b-e0808c7264cd@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Wednesday, 25 April 2018 13:10:43 EEST Tomi Valkeinen wrote:
> On 25/04/18 13:02, Laurent Pinchart wrote:
> > On Wednesday, 25 April 2018 12:33:53 EEST Tomi Valkeinen wrote:
> >> On 25/04/18 12:03, Laurent Pinchart wrote:
> >>> Could we trim down omapfb to remove support for the devices supported by
> >>> omapdrm ?
> >> 
> >> I was thinking about just that. But, of course, it's not quite
> >> straightforward either.
> >> 
> >> We've got DSI manual update functionality in OMAP3-OMAP5 SoCs, which
> >> covers a lot of devices.
> > 
> > Sebastian is working on getting that feature in omapdrm, isn't he ?
> 
> Yes, and I keep pushing it forward because of the restructuring you're
> doing =) (feel free to comment on that thread). But agreed, it's getting
> better. When we have manual update support, I think the biggest missing
> feature is then in omapdrm.
> 
> >> And VRFB on OMAP2/3.
> > 
> > And that's something I'd really like to have in omapdrm too.
> 
> Considering how much headache TILER has given, I'm not exactly looking
> forward to it ;).
> 
> If we get manual update and VRFB, I think we are more or less covered on
> the supported HW features. It'll still break userspace apps which use
> omapfb, though. Unless we also port the omapfb specific IOCTLs and the
> sysfs files, which I believe we should not.

I agree with you, we shouldn't. We'll need a grace period before removing 
omapfb, if we ever do so.

-- 
Regards,

Laurent Pinchart
