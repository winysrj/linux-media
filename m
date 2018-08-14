Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37504 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbeHNRx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:53:29 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/14] staging: media: tegra-vde: Support BSEV clock and reset
Date: Tue, 14 Aug 2018 18:05:51 +0300
Message-ID: <1939648.kLoYIjBhCz@dimapc>
In-Reply-To: <20180814142124.GA21075@ulmo>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <2754354.GStWHyBo4g@dimapc> <20180814142124.GA21075@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 14 August 2018 17:21:24 MSK Thierry Reding wrote:
> On Mon, Aug 13, 2018 at 06:09:46PM +0300, Dmitry Osipenko wrote:
> > On Monday, 13 August 2018 17:50:14 MSK Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > The BSEV clock has a separate gate bit and can not be assumed to be
> > > always enabled. Add explicit handling for the BSEV clock and reset.
> > > 
> > > This fixes an issue on Tegra124 where the BSEV clock is not enabled
> > > by default and therefore accessing the BSEV registers will hang the
> > > CPU if the BSEV clock is not enabled and the reset not deasserted.
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > 
> > Are you sure that BSEV clock is really needed for T20/30? I've tried
> > already to disable the clock explicitly and everything kept working,
> > though I'll try again.
> 
> I think you're right that these aren't strictly required for VDE to work
> on Tegra20 and Tegra30. However, the BSEV clock and reset do exist on
> those platforms, so I didn't see a reason why they shouldn't be handled
> uniformly across all generations.

It's a bit messy to have unsed clock being enabled.

I guess BSEV clock on T20/30 only enables the AES engine. If the decryption 
engine is integrated with the video decoder, then the clock and reset should 
be requested by the driver, but BSEV should be kept disabled if it's not used.

If BSEV clock isn't powering anything related to VDE on T20/30, then let's 
make BSEV clock and reset control optional. For the clock we could check 
whether err = -ENOENT and continue, later we may switch to 
devm_clk_get_optional() of the upcoming [0]. For the reset there is 
devm_reset_control_get_optional(). 

Please try to verify by all means that we can omit BSEV on T20/30. If you are 
not sure, then let's make them optional as we can always make them required 
later.

P.S. I'll test and review all the patches during the next days. 

[0] https://lkml.org/lkml/2018/7/18/460
