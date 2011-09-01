Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47800 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab1IAIK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 04:10:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Getting started with OMAP3 ISP
Date: Thu, 1 Sep 2011 10:11:25 +0200
Cc: linux-media@vger.kernel.org
References: <4E56734A.3080001@mlbassoc.com> <201108311833.24394.laurent.pinchart@ideasonboard.com> <4E5EB6EC.1000400@mlbassoc.com>
In-Reply-To: <4E5EB6EC.1000400@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011011.26933.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Thursday 01 September 2011 00:34:20 Gary Thomas wrote:
> On 2011-08-31 10:33, Laurent Pinchart wrote:
> > On Wednesday 31 August 2011 18:25:28 Enrico wrote:
> >> On Wed, Aug 31, 2011 at 5:15 PM, Laurent Pinchart wrote:
> >>> I've just sent three preliminary patches to the list to add YUYV
> >>> support in the OMAP3 ISP CCDC.
> >> 
> >> What tree are those based on?
> > 
> > On
> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > omap3isp-next (sorry for not mentioning it), but the patch set was
> > missing a patch. I've sent a v2.
> 
> Sorry to be a pain, but is there an easy way to generate a patchset for
> this tree against the vanilla released 3.0 tree?  (that's what my tree is
> using)

You can apply the 4 YUV patches I've sent to the list only. They won't apply 
cleanly though, you will need to fix them.

-- 
Regards,

Laurent Pinchart
