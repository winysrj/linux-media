Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33943 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbFWHjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 03:39:17 -0400
Date: Tue, 23 Jun 2015 09:39:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com,
	fengguang.wu@intel.com, linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH 2/2] x86/mm/pat, drivers/media/ivtv: replace WARN() with
 pr_warn()
Message-ID: <20150623073911.GB21872@gmail.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
 <1435012318-381-3-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435012318-381-3-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> On built-in kernels this will always splat. Fix that.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  drivers/media/pci/ivtv/ivtvfb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> index 4cb365d..6f0c364 100644
> --- a/drivers/media/pci/ivtv/ivtvfb.c
> +++ b/drivers/media/pci/ivtv/ivtvfb.c
> @@ -38,6 +38,8 @@
>      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/fb.h>
> @@ -1266,8 +1268,8 @@ static int __init ivtvfb_init(void)
>  	int err;
>  
>  #ifdef CONFIG_X86_64
> -	if (WARN(pat_enabled(),
> -		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n")) {
> +	if (pat_enabled()) {
> +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
>  		return -ENODEV;
>  	}

So why should a built-in kernel bzImage with this driver enabled but the driver 
not present print this warning?

Why not only print in a code path where we know the hardware is present? 

allyesconfig bootups are noisy enough as-is ...

Thanks,

	Ingo
