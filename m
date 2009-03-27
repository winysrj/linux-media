Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:33463 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZC0TJN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 15:09:13 -0400
Message-ID: <49CD2453.4090906@gmail.com>
Date: Fri, 27 Mar 2009 23:09:07 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Artem Makhutov <artem@makhutov.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove debug output from stb6100_cfg.h
References: <20090326094553.GA12847@titan.makhutov-it.de> <20090327142417.4d80f166@pedra.chehab.org>
In-Reply-To: <20090327142417.4d80f166@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Manu,
> 
> If ok to you, please ack.
> 
> On Thu, 26 Mar 2009 10:45:53 +0100
> Artem Makhutov <artem@makhutov.org> wrote:
> 
> This patch removes the debug output from stb6100_cfg.h as it is flooding
> the syslog with tuning data during normal operation.
> 
> Signed-off-by: Artem Makhutov <artem@makhutov.org>
>

Looks okay,

Acked-by: Manu Abraham <abraham.manu@linuxtv.org>


> --- linux.old/drivers/media/dvb/frontends/stb6100_cfg.h	2009-03-26 10:28:57.000000000 +0100
> +++ linux/drivers/media/dvb/frontends/stb6100_cfg.h	2009-03-26 10:29:52.000000000 +0100
> @@ -36,7 +36,6 @@
>  			return err;
>  		}
>  		*frequency = t_state.frequency;
> -		printk("%s: Frequency=%d\n", __func__, t_state.frequency);
>  	}
>  	return 0;
>  }
> @@ -59,7 +58,6 @@
>  			return err;
>  		}
>  	}
> -	printk("%s: Frequency=%d\n", __func__, t_state.frequency);
>  	return 0;
>  }
>  
> @@ -81,7 +79,6 @@
>  		}
>  		*bandwidth = t_state.bandwidth;
>  	}
> -	printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
>  	return 0;
>  }
>  
> @@ -103,6 +100,5 @@
>  			return err;
>  		}
>  	}
> -	printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
>  	return 0;
>  }
> 
