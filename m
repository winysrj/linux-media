Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:57472 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180AbaBTNRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 08:17:11 -0500
Message-ID: <53060055.2010408@free-electrons.com>
Date: Thu, 20 Feb 2014 14:17:09 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: m.chehab@samsung.com, gregkh@linuxfoundation.org,
	prabhakar.csengg@gmail.com, yongjun_wei@trendmicro.com.cn,
	sakari.ailus@iki.fi, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
References: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com> <1386584182-5400-1-git-send-email-michael.opdenacker@free-electrons.com> <4210530.AR5GZgidVz@avalon>
In-Reply-To: <4210530.AR5GZgidVz@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/20/2014 12:36 PM, Laurent Pinchart wrote:
> Hi Michael,
>
> What's the status of this patch ? Do expect Prabhakar to pick it up, or do you 
> plan to push all your IRQF_DISABLED removal patches in one go ?
It's true a good number of my patches haven't been picked up yet, even
after multiple resends.

I was planning to ask the community tomorrow about what to do to finally
get rid of IRQF_DISABLED. Effectively, pushing all the remaining changes
in one go (or removing the definition of IRQF_DISABLED) may be the final
solution.

I hope to be able to answer your question by the end of the week.

Thanks for getting back to me about this!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

