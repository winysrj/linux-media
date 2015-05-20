Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59959 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbbETJmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 05:42:40 -0400
Message-ID: <1432114959.4466.10.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: remove extraneous TRACE_SYSTEM_STRING
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Kamil Debski <k.debski@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 20 May 2015 11:42:39 +0200
In-Reply-To: <4790110.OLqddgPxAn@wuerfel>
References: <4790110.OLqddgPxAn@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 19.05.2015, 23:34 +0200 schrieb Arnd Bergmann:
> The coda tracing code causes lots of warnings like
> 
> In file included from /git/arm-soc/include/trace/define_trace.h:90:0,
>                  from /git/arm-soc/drivers/media/platform/coda/trace.h:203,
>                  from /git/arm-soc/drivers/media/platform/coda/coda-bit.c:34:
> /git/arm-soc/include/trace/ftrace.h:28:0: warning: "TRACE_SYSTEM_STRING" redefined
>  #define TRACE_SYSTEM_STRING __app(TRACE_SYSTEM_VAR,__trace_system_name)
>  ^
> In file included from /git/arm-soc/include/trace/define_trace.h:83:0,
>                  from /git/arm-soc/drivers/media/platform/coda/trace.h:203,
>                  from /git/arm-soc/drivers/media/platform/coda/coda-bit.c:34:
> /git/arm-soc/drivers/media/platform/coda/./trace.h:12:0: note: this is the location of the previous definition
>  #define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)
> 
> From what I can tell, this is just the result of a bogus TRACE_SYSTEM_STRING
> definition, and removing that one makes the warnings go away.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 9a1a8f9953f ("[media] coda: Add tracing support")
> 
> diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
> index d1d06cbd1f6a..781bf7286d53 100644
> --- a/drivers/media/platform/coda/trace.h
> +++ b/drivers/media/platform/coda/trace.h
> @@ -9,8 +9,6 @@
>  
>  #include "coda.h"
>  
> -#define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)
> -
>  TRACE_EVENT(coda_bit_run,
>  	TP_PROTO(struct coda_ctx *ctx, int cmd),

Steven sent the same fix to linux-next recently ("[PATCH][linux-next]
coda: Do not define TRACE_SYSTEM_STRING"). As he points out, this is the
result of a bogus copy & paste. Kamil, would you queue either of them
with my
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

