Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:54384 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbbC1Ow2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2015 10:52:28 -0400
Message-ID: <5516BE45.6030304@schinagl.nl>
Date: Sat, 28 Mar 2015 15:44:21 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: Jonathan McCrohan <jmccrohan@gmail.com>,
	linux-media@vger.kernel.org
CC: Brian Burch <brian@pingtoo.com>
Subject: Re: [PATCH] dtv-scan-tables: update dvb-t/au-SunshineCoast
References: <1426938040-5806-1-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1426938040-5806-1-git-send-email-jmccrohan@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks guys,

applied and pushed :)

On 03/21/2015 12:40 PM, Jonathan McCrohan wrote:
> From: Brian Burch <brian@pingtoo.com>
>
> Update dvb-t/au-SunshineCoast as per Brian Burch's bug report on Ubuntu
> Launchpad:
> https://bugs.launchpad.net/ubuntu/+source/dtv-scan-tables/+bug/1415262
>
> Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
> ---
>   dvb-t/au-SunshineCoast | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/dvb-t/au-SunshineCoast b/dvb-t/au-SunshineCoast
> index 5d22931..ff6f5dd 100644
> --- a/dvb-t/au-SunshineCoast
> +++ b/dvb-t/au-SunshineCoast
> @@ -1,8 +1,8 @@
>   # Australia / Sunshine Coast
> -# SBS36 SBS ***
> +# SBS40 SBS ***
>   [CHANNEL]
>   	DELIVERY_SYSTEM = DVBT
> -	FREQUENCY = 585625000
> +	FREQUENCY = 613500000
>   	BANDWIDTH_HZ = 7000000
>   	CODE_RATE_HP = 2/3
>   	CODE_RATE_LP = NONE
> @@ -12,10 +12,10 @@
>   	HIERARCHY = NONE
>   	INVERSION = AUTO
>   
> -# TNQ47 10 ***
> +# TNQ44 10 ***
>   [CHANNEL]
>   	DELIVERY_SYSTEM = DVBT
> -	FREQUENCY = 662625000
> +	FREQUENCY = 641500000
>   	BANDWIDTH_HZ = 7000000
>   	CODE_RATE_HP = 3/4
>   	CODE_RATE_LP = NONE
> @@ -25,10 +25,10 @@
>   	HIERARCHY = NONE
>   	INVERSION = AUTO
>   
> -# ABQ62 ABC ***
> +# ABC41 ABC ***
>   [CHANNEL]
>   	DELIVERY_SYSTEM = DVBT
> -	FREQUENCY = 767625000
> +	FREQUENCY = 620500000
>   	BANDWIDTH_HZ = 7000000
>   	CODE_RATE_HP = 3/4
>   	CODE_RATE_LP = NONE
> @@ -38,10 +38,10 @@
>   	HIERARCHY = NONE
>   	INVERSION = AUTO
>   
> -# STQ65 7 ***
> +# STQ42 7 ***
>   [CHANNEL]
>   	DELIVERY_SYSTEM = DVBT
> -	FREQUENCY = 788625000
> +	FREQUENCY = 627500000
>   	BANDWIDTH_HZ = 7000000
>   	CODE_RATE_HP = 3/4
>   	CODE_RATE_LP = NONE
> @@ -51,10 +51,10 @@
>   	HIERARCHY = NONE
>   	INVERSION = AUTO
>   
> -# STQ68 WIN ***
> +# RTQ43 WIN ***
>   [CHANNEL]
>   	DELIVERY_SYSTEM = DVBT
> -	FREQUENCY = 809500000
> +	FREQUENCY = 634500000
>   	BANDWIDTH_HZ = 7000000
>   	CODE_RATE_HP = 3/4
>   	CODE_RATE_LP = NONE

