Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:35196 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754054Ab1AGTBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 14:01:51 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch v2] [media] av7110: check for negative array offset
Date: Fri, 7 Jan 2011 20:01:19 +0100
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110106194059.GC1717@bicker> <4D270A9F.7080104@linuxtv.org> <20110107134651.GH1717@bicker>
In-Reply-To: <20110107134651.GH1717@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101072001.20850@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 07 January 2011 14:46:51 Dan Carpenter wrote:
> info->num comes from the user.  It's type int.  If the user passes
> in a negative value that would cause memory corruption.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> V2: change the check instead of making num and unsigned int
> 
> diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
> index 122c728..923a8e2 100644
> --- a/drivers/media/dvb/ttpci/av7110_ca.c
> +++ b/drivers/media/dvb/ttpci/av7110_ca.c
> @@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
>  	{
>  		ca_slot_info_t *info=(ca_slot_info_t *)parg;
>  
> -		if (info->num > 1)
> +		if ((unsigned)info->num > 1)
>  			return -EINVAL;
>  		av7110->ci_slot[info->num].num = info->num;
>  		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Imho casts are a last resort and should be avoided, if there is a better
way to do it. The obvious fix is

  if (info->num < 0 || info->num > 1)
        return -EINVAL;
   
CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
