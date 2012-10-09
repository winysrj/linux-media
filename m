Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2JIW2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 18:28:35 -0400
Date: Tue, 9 Oct 2012 19:28:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] omap3isp: Replace
 cpu_is_omap3630() with ISP revision check
Message-ID: <20121009192830.7063fc05@redhat.com>
In-Reply-To: <1525824.Ct8mi0Nuxy@avalon>
References: <E1TKWPT-000144-3I@www.linuxtv.org>
	<1525824.Ct8mi0Nuxy@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Oct 2012 22:33:59 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Mauro,
> 
> On Saturday 06 October 2012 17:31:58 Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following
> > patch were queued at the http://git.linuxtv.org/media_tree.git tree:
> 
> Please don't. I haven't even sent a pull request for that patch. I don't 
> consider it as being ready yet, as Sakari pointed out we need to investigate 
> whether the right fix shouldn't be at the OMAP3 clocks level instead.

Reverting it, as requested.

Regards,
Mauro
