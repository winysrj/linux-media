Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3GEKrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 06:47:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jakub Piotr =?utf-8?B?Q8WCYXBh?= <jpc-ml@zenburn.net>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
Date: Fri, 05 Jul 2013 12:48:16 +0200
Message-ID: <1604535.2Z0SUEyxcF@avalon>
In-Reply-To: <51D5F8FC.4040504@zenburn.net>
References: <51D37796.2000601@zenburn.net> <2398527.WgqgO0AkRo@avalon> <51D5F8FC.4040504@zenburn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakub,

On Friday 05 July 2013 00:36:44 Jakub Piotr Cłapa wrote:
> Hi Laurent,
> 
> On 04.07.13 23:11, Laurent Pinchart wrote:
> > The omap3isp/xclk clock branch was used only to push patches to the media
> > tree, I should have deleted it afterwards. Mike's reentrancy patches were
> > already merged (or scheduled for merge) in mainline at that time, and for
> > technical reasons they were not present in the omap3isp/xclk branch.
> 
> Thanks for the explanation. It would be great if you could update your
> board/beagle/mt9p031 branch and include the discussed changes.

Done. Could you please test it ?

> I belive your branch is the only authoritative source of magic required to
> get the Aptina+Beagle combination going.

I need to add DT bindings to the OMAP3 ISP driver. Once done everything could 
be merged upstream.

> > I've now deleted the branch from the public tree, sorry for the confusion.
> 
> Not a problem at all. The confusion was worse when I was trying to apply
> random patch files found via Google. ;)

:-)

-- 
Regards,

Laurent Pinchart

