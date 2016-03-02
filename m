Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33627 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbcCBNRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 08:17:15 -0500
Received: by mail-lb0-f172.google.com with SMTP id k15so6930220lbg.0
        for <linux-media@vger.kernel.org>; Wed, 02 Mar 2016 05:17:14 -0800 (PST)
Subject: Re: [PATCH v2] media: platform: rcar_jpu, sh_vou, vsp1: Use
 ARCH_RENESAS
To: Simon Horman <horms+renesas@verge.net.au>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1456881291-1167-1-git-send-email-horms+renesas@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56D6E7D6.1010806@cogentembedded.com>
Date: Wed, 2 Mar 2016 16:17:10 +0300
MIME-Version: 1.0
In-Reply-To: <1456881291-1167-1-git-send-email-horms+renesas@verge.net.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 3/2/2016 4:14 AM, Simon Horman wrote:

> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
>
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
>
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
> Based on media-tree/master
>
> v2
> * Do not update VIDEO_SH_VOU to use ARCH_RENESAS as this is
>    used by some SH-based platforms and is not used by any ARM-based platforms
>    so a dependency on ARCH_SHMOBILE is correct for that driver

    You forgot to remove it from the subject though.

> * Added Geert Uytterhoeven's Ack
[...]

MBR, Sergei

