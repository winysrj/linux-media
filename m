Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39613 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3GDWgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jul 2013 18:36:53 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so1088858eak.36
        for <linux-media@vger.kernel.org>; Thu, 04 Jul 2013 15:36:52 -0700 (PDT)
Message-ID: <51D5F8FC.4040504@zenburn.net>
Date: Fri, 05 Jul 2013 00:36:44 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
References: <51D37796.2000601@zenburn.net> <51D5D967.1030306@zenburn.net> <2398527.WgqgO0AkRo@avalon>
In-Reply-To: <2398527.WgqgO0AkRo@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 04.07.13 23:11, Laurent Pinchart wrote:
> The omap3isp/xclk clock branch was used only to push patches to the media
> tree, I should have deleted it afterwards. Mike's reentrancy patches were
> already merged (or scheduled for merge) in mainline at that time, and for
> technical reasons they were not present in the omap3isp/xclk branch.

Thanks for the explanation. It would be great if you could update your 
board/beagle/mt9p031 branch and include the discussed changes. I belive 
your branch is the only authoritative source of magic required to get 
the Aptina+Beagle combination going.

> I've now deleted the branch from the public tree, sorry for the confusion.

Not a problem at all. The confusion was worse when I was trying to apply 
random patch files found via Google. ;)

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
