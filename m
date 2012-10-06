Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:56972 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2JFLAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 07:00:34 -0400
Date: Sat, 6 Oct 2012 13:00:17 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 1/3] mt9v022: add v4l2 controls for blanking
Message-ID: <20121006130017.2f95b740@wker>
In-Reply-To: <1348783425-22934-1-git-send-email-agust@denx.de>
References: <1345799431-29426-2-git-send-email-agust@denx.de>
	<1348783425-22934-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 28 Sep 2012 00:03:45 +0200
Anatolij Gustschin <agust@denx.de> wrote:

> Add controls for horizontal and vertical blanking. Also add an error
> message for case that the control handler init failed. Since setting
> the blanking registers is done by controls now, we shouldn't change
> these registers outside of the control function. Use v4l2_ctrl_s_ctrl()
> to set them.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
> Changes since first version:
>  - drop analog and reg32 setting controls
>  - use more descriptive error message for handler init error
>  - revise commit log
>  - rebase on staging/for_v3.7 branch
> 
>  drivers/media/i2c/soc_camera/mt9v022.c |   49 +++++++++++++++++++++++++++++--
>  1 files changed, 45 insertions(+), 4 deletions(-)

Can these mt9v022 patches be queued for mainlining, please?

Thanks,
Anatolij
