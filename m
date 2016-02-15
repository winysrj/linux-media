Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55865 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbcBOM0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 07:26:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Mon, 15 Feb 2016 14:26:52 +0200
Message-ID: <1476630.57H4jvboVb@avalon>
In-Reply-To: <CAMuHMdVoZ31hA6hitMhjWxizoEAPdYM1rubx4LRg275Lvz2Duw@mail.gmail.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdVoZ31hA6hitMhjWxizoEAPdYM1rubx4LRg275Lvz2Duw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 15 February 2016 10:22:22 Geert Uytterhoeven wrote:
> On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart wrote:
> > The parent clock isn't documented in the datasheet, use S2D1 as a best
> > guess for now.
> 
> Looks like a good guess...
> I assume the driver doesn't depend on the clock rate?

Correct.

> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thank you.

-- 
Regards,

Laurent Pinchart

