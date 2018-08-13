Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38500 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbeHMRwk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:52:40 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/14] staging: media: tegra-vde: Support BSEV clock and reset
Date: Mon, 13 Aug 2018 18:09:46 +0300
Message-ID: <2754354.GStWHyBo4g@dimapc>
In-Reply-To: <20180813145027.16346-2-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-2-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:14 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The BSEV clock has a separate gate bit and can not be assumed to be
> always enabled. Add explicit handling for the BSEV clock and reset.
> 
> This fixes an issue on Tegra124 where the BSEV clock is not enabled
> by default and therefore accessing the BSEV registers will hang the
> CPU if the BSEV clock is not enabled and the reset not deasserted.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Are you sure that BSEV clock is really needed for T20/30? I've tried already 
to disable the clock explicitly and everything kept working, though I'll try 
again.

The device-tree changes should be reflected in the binding documentation.
