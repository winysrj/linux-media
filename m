Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:39852 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbdHTLwH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:52:07 -0400
Date: Sun, 20 Aug 2017 13:29:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org, daniel.vetter@intel.com,
        jani.nikula@linux.intel.com, seanpaul@chromium.org,
        airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        boris.brezillon@free-electrons.com, marek.vasut@gmail.com,
        richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se,
        kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org,
        ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/15] EDAC: make device_type const
Message-ID: <20170820112954.bi5oiebbm3i4gtru@pd.tnic>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-2-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1503130946-2854-2-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 19, 2017 at 01:52:12PM +0530, Bhumika Goyal wrote:
> Make these const as they are only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/edac/edac_mc_sysfs.c | 8 ++++----
>  drivers/edac/i7core_edac.c   | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
