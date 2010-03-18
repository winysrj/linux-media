Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59734 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CRLZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 07:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1003171103030.4354@axis700.grange>
References: <Pine.LNX.4.64.1003171103030.4354@axis700.grange>
Date: Thu, 18 Mar 2010 20:25:06 +0900
Message-ID: <aec7e5c31003180425l5066edffl4eda8804278b42d8@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] V4L: SuperH Video Output Unit (VOU) driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Guennadi,

On Thu, Mar 18, 2010 at 7:28 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> A number of SuperH SoCs, including sh7724, include a Video Output Unit. This
> patch adds a video (V4L2) output driver for it. The driver uses v4l2-subdev and
> mediabus APIs to interface to TV encoders.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

Thanks for your work on this. The VOU block is actually used by the
SH-Mobile series of SoCs. So you may want to throw in a "mobile" there
in you description to avoid future name space collisions.

I'll make sure that people test your V2 patch.

Is both NTSC and PAL known to be ok with v2?

Thanks,

/ magnus
