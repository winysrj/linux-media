Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm21-vm5.bullet.mail.ird.yahoo.com ([212.82.109.245]:31138 "HELO
	nm21-vm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754484Ab2HYHM0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 03:12:26 -0400
Message-ID: <1345878743.62338.YahooMailClassic@web29404.mail.ird.yahoo.com>
Date: Sat, 25 Aug 2012 08:12:23 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [v3 1/1] driver-core: Shut up dev_dbg_reatelimited() without DEBUG
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"1345726463.82057.YahooMailClassic@web29403.mail.ird.yahoo.com"
	<1345726463.82057.YahooMailClassic@web29403.mail.ird.yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"joe@perches.com" <joe@perches.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"crope@iki.fi" <crope@iki.fi>
In-Reply-To: <20120824.073535.1710298672594744200.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 24/8/12, Hiroshi Doyu <hdoyu@nvidia.com> wrote:

> From: Hiroshi Doyu <hdoyu@nvidia.com>
> Subject: [v3 1/1] driver-core: Shut up dev_dbg_reatelimited() without DEBUG
> To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "joe@perches.com" <joe@perches.com>, "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, "crope@iki.fi" <crope@iki.fi>
> Date: Friday, 24 August, 2012, 5:35
> dev_dbg_reatelimited() without DEBUG
> printed "217078 callbacks
> suppressed". This shouldn't print anything without DEBUG.
> 
> With CONFIG_DYNAMIC_DEBUG, the print should be configured as
> expected.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> Tested-by: Antti Palosaari <crope@iki.fi>
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Went ahead and patched my 2.5.x distro kernel-devel package header, and it works as expected. Apologies about the red-herring with media_build (for those who are not familar with it, = "back-port" wrapper package for building new DVB modules against older kernels). 

The distro kernel-devel headers is per installed distro kernel so will be replaced in a week or two... no permanent demage done :-).   

> ---
>  include/linux/device.h |   62
> +++++++++++++++++++++++++++++------------------
>  1 files changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/device.h
> b/include/linux/device.h
> index 9648331..bb6ffcb 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -932,6 +932,32 @@ int _dev_info(const struct device *dev,
> const char *fmt, ...)
>  
>  #endif
>  
> +/*
> + * Stupid hackaround for existing uses of non-printk uses
> dev_info
> + *
> + * Note that the definition of dev_info below is actually
> _dev_info
> + * and a macro is used to avoid redefining dev_info
> + */
> +
> +#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt,
> ##arg)
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +#define dev_dbg(dev, format, ...)   
>          \
> +do {       
>            
>          \
> +    dynamic_dev_dbg(dev, format,
> ##__VA_ARGS__); \
> +} while (0)
> +#elif defined(DEBUG)
> +#define dev_dbg(dev, format, arg...)   
>     \
> +    dev_printk(KERN_DEBUG, dev, format,
> ##arg)
> +#else
> +#define dev_dbg(dev, format, arg...)   
>             \
> +({           
>            
>         \
> +    if (0)   
>            
>             \
> +       
> dev_printk(KERN_DEBUG, dev, format,
> ##arg);    \
> +    0;       
>            
>         \
> +})
> +#endif
> +
>  #define dev_level_ratelimited(dev_level, dev, fmt,
> ...)           
> \
>  do {       
>            
>            
>     \
>      static
> DEFINE_RATELIMIT_STATE(_rs,   
>             \
> @@ -955,33 +981,21 @@ do {   
>            
>            
>         \
>      dev_level_ratelimited(dev_notice, dev,
> fmt, ##__VA_ARGS__)
>  #define dev_info_ratelimited(dev, fmt,
> ...)           
>     \
>      dev_level_ratelimited(dev_info, dev,
> fmt, ##__VA_ARGS__)
> +#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
>  #define dev_dbg_ratelimited(dev, fmt,
> ...)           
>     \
> -    dev_level_ratelimited(dev_dbg, dev, fmt,
> ##__VA_ARGS__)
> -
> -/*
> - * Stupid hackaround for existing uses of non-printk uses
> dev_info
> - *
> - * Note that the definition of dev_info below is actually
> _dev_info
> - * and a macro is used to avoid redefining dev_info
> - */
> -
> -#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt,
> ##arg)
> -
> -#if defined(CONFIG_DYNAMIC_DEBUG)
> -#define dev_dbg(dev, format, ...)   
>          \
> -do {       
>            
>          \
> -    dynamic_dev_dbg(dev, format,
> ##__VA_ARGS__); \
> +do {       
>            
>            
>     \
> +    static
> DEFINE_RATELIMIT_STATE(_rs,   
>             \
> +           
>          
> DEFAULT_RATELIMIT_INTERVAL,    \
> +           
>          
> DEFAULT_RATELIMIT_BURST);   
>     \
> +   
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,
> fmt);       
>     \
> +    if (unlikely(descriptor.flags &
> _DPRINTK_FLAGS_PRINT) &&    \
> +       
> __ratelimit(&_rs))       
>            
>     \
> +       
> __dynamic_pr_debug(&descriptor,
> pr_fmt(fmt),        \
> +           
>    
>    ##__VA_ARGS__);   
>         \
>  } while (0)
> -#elif defined(DEBUG)
> -#define dev_dbg(dev, format, arg...)   
>     \
> -    dev_printk(KERN_DEBUG, dev, format,
> ##arg)
>  #else
> -#define dev_dbg(dev, format, arg...)   
>             \
> -({           
>            
>         \
> -    if (0)   
>            
>             \
> -       
> dev_printk(KERN_DEBUG, dev, format,
> ##arg);    \
> -    0;       
>            
>         \
> -})
> +#define dev_dbg_ratelimited(dev, fmt,
> ...)           
> \
> +    no_printk(KERN_DEBUG pr_fmt(fmt),
> ##__VA_ARGS__)
>  #endif
>  
>  #ifdef VERBOSE_DEBUG
> -- 
> 1.7.5.4
> 
