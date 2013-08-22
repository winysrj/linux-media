Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60673 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3HVL2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 07:28:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com, sakari.ailus@iki.fi
Subject: Re: How to express planar formats with mediabus format code?
Date: Thu, 22 Aug 2013 13:29:59 +0200
Message-ID: <2368703.nsGl321KOP@avalon>
In-Reply-To: <CALxrGmVHS2BnmyLd4EDEHJ-CB44e-AfdFqj0pVFTa_hbBhgWAA@mail.gmail.com>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com> <2205654.JNC8mWJ5su@avalon> <CALxrGmVHS2BnmyLd4EDEHJ-CB44e-AfdFqj0pVFTa_hbBhgWAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiaquan,

On Wednesday 21 August 2013 18:14:50 Su Jiaquan wrote:
> On Tue, Aug 20, 2013 at 8:53 PM, Laurent Pinchart wrote:
> > Hi Jiaquan,
> > 
> > I'm not sure if that's needed here. Vendor-specific formats still need to
> > be documented, so we could just create a custom YUV format for your case.
> > Let's start with the beginning, could you describe what gets transmitted
> > on the bus when that special format is selected ?
> 
> For YUV420P format, the data format sent from IPC is similar to
> V4L2_MBUS_FMT_YUYV8_1_5X8, but the content for each line is different:
> For odd line, it's YYU YYU YYU... For even line, it's YYV YYV YYV...
> then DMA engine send them to RAM in planar format.
> 
> For YUV420SP format, the data format sent from IPC is YYUV YYUV
> YYUV(maybe called V4L2_MBUS_FMT_YYUV8_2X8?), but DMA engine drop UV
> every other line, then send them to RAM as semi-planar.

V4L2_MBUS_FMT_YYUV8_2X8 looks good to me.

> Well, the first data format is too odd, I don't have a clue how to
> call it, do you have suggestion?

Maybe V4L2_MBUS_FMT_YU8_YV8_1_5X8 ? I've CC'ed Sakari Ailus, he's often pretty 
creative for these issues.

-- 
Regards,

Laurent Pinchart

