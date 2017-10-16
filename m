Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51685 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932131AbdJPVKT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 17:10:19 -0400
Date: Tue, 17 Oct 2017 08:10:15 +1100
From: "Tobin C. Harding" <me@tobin.cc>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] stagin: atomisp: Fix oops by unbalanced clk
 enable/disable call
Message-ID: <20171016211015.GL16106@eros>
References: <20171016123448.12014-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016123448.12014-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 16, 2017 at 02:34:48PM +0200, Hans de Goede wrote:
> The common-clk core expects clk consumers to always call enable/disable
> in a balanced manner. The atomisp driver does not call gmin_flisclk_ctrl()
> in a balanced manner, so add a clock_on bool and skip redundant calls.
> 
> This fixes kernel oops like this one:
> 
> [   19.811613] gc0310_s_config S
> [   19.811655] ------------[ cut here ]------------
> [   19.811664] WARNING: CPU: 1 PID: 720 at drivers/clk/clk.c:594 clk_core_disabl
> [   19.811666] Modules linked in: tpm_crb(+) snd_soc_sst_atom_hifi2_platform tpm
> [   19.811744] CPU: 1 PID: 720 Comm: systemd-udevd Tainted: G         C OE   4.1
> [   19.811746] Hardware name: Insyde T701/T701, BIOS BYT70A.YNCHENG.WIN.007 08/2
> [   19.811749] task: ffff988df7ab2500 task.stack: ffffac1400474000
> [   19.811752] RIP: 0010:clk_core_disable+0xc0/0x130
> ...
> [   19.811775] Call Trace:
> [   19.811783]  clk_core_disable_lock+0x1f/0x30
> [   19.811788]  clk_disable+0x1f/0x30
> [   19.811794]  gmin_flisclk_ctrl+0x87/0xf0
> [   19.811801]  0xffffffffc0528512
> [   19.811805]  0xffffffffc05295e2
> [   19.811811]  ? acpi_device_wakeup_disable+0x50/0x60
> [   19.811815]  ? acpi_dev_pm_attach+0x8e/0xd0
> [   19.811818]  ? 0xffffffffc05294d0
> [   19.811823]  i2c_device_probe+0x1cd/0x280
> [   19.811828]  driver_probe_device+0x2ff/0x450
> 
> Fixes: "staging: atomisp: use clock framework for camera clocks"
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c       | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> index 828fe5abd832..6671ebe4ecc9 100644
> --- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> +++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> @@ -29,6 +29,7 @@ struct gmin_subdev {
>  	struct v4l2_subdev *subdev;
>  	int clock_num;
>  	int clock_src;
> +	bool clock_on;
>  	struct clk *pmc_clk;
>  	struct gpio_desc *gpio0;
>  	struct gpio_desc *gpio1;
> @@ -583,6 +584,9 @@ static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
>  	struct gmin_subdev *gs = find_gmin_subdev(subdev);
>  	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>  
> +	if (gs->clock_on == !!on)
> +		return 0;
> +
>  	if (on) {
>  		ret = clk_set_rate(gs->pmc_clk, gs->clock_src);

Which tree [and branch] are you working off please? In the staging-next branch of Greg's staging
tree this function does not appear as it is in this patch.

thanks,
Tobin.
