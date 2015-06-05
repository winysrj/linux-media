Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:57870 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbbFENdb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 09:33:31 -0400
Date: Fri, 5 Jun 2015 15:33:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
	kbuild-all@01.org, Borislav Petkov <bp@suse.de>,
	Doug Thompson <dougthompson@xmission.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bp] EDAC, mce_amd_inj: inj_type can be static
Message-ID: <20150605133327.GG3679@pd.tnic>
References: <201506051907.ofv5fD3p%fengguang.wu@intel.com>
 <20150605112426.GA97073@lkp-sb04>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150605112426.GA97073@lkp-sb04>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 05, 2015 at 07:24:26PM +0800, kbuild test robot wrote:
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  mce_amd_inj.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
> index 2a0c829..46a6b0e 100644
> --- a/drivers/edac/mce_amd_inj.c
> +++ b/drivers/edac/mce_amd_inj.c
> @@ -44,7 +44,7 @@ static const char * const flags_options[] = {
>  };
>  
>  /* Set default injection to SW_INJ */
> -enum injection_type inj_type = SW_INJ;
> +static enum injection_type inj_type = SW_INJ;
>  
>  #define MCE_INJECT_SET(reg)						\
>  static int inj_##reg##_set(void *data, u64 val)				\

Thanks kbuild test robot, applied!

:-D

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
