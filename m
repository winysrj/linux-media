Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58202 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLCSFx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 13:05:53 -0500
Subject: Re: [PATCH] kernel-doc: parse DECLARE_KFIFO_PTR()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
References: <a0a0392564bd4405b919241de9fb0fc7ec9be8cd.1512049320.git.mchehab@s-opensource.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <445d4898-2523-7263-ee15-ccd0a658a51d@infradead.org>
Date: Sun, 3 Dec 2017 10:05:50 -0800
MIME-Version: 1.0
In-Reply-To: <a0a0392564bd4405b919241de9fb0fc7ec9be8cd.1512049320.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/2017 05:42 AM, Mauro Carvalho Chehab wrote:
> On media, we now have an struct declared with:
> 
[snip]
> 
> So, teach kernel-doc how to parse a DECLARE_KFIFO_PTR();
> 
> While here, relax at the past DECLARE_foo() macros,
> accepting a random number of spaces after comma.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Hi,

Would you mind adding the parsing of DECLARE_KFIFO() also?

../drivers/gpio/gpiolib.c:601: warning: No description found for parameter '16'
../drivers/gpio/gpiolib.c:601: warning: Excess struct member 'events' description in 'lineevent_state'

struct lineevent_state {
	struct gpio_device *gdev;
	const char *label;
	struct gpio_desc *desc;
	u32 eflags;
	int irq;
	wait_queue_head_t wait;
	DECLARE_KFIFO(events, struct gpioevent_data, 16);
	struct mutex read_lock;
};

> ---
>  scripts/kernel-doc | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index bd29a92b4b48..5c12208f8c89 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2208,10 +2208,11 @@ sub dump_struct($$) {
>  	$members =~ s/__aligned\s*\([^;]*\)//gos;
>  	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
>  	# replace DECLARE_BITMAP
> -	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
> +	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
>  	# replace DECLARE_HASHTABLE
> -	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> -
> +	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> +	# replace DECLARE_KFIFO_PTR(fifo, type)
> +	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
>  	create_parameterlist($members, ';', $file);
>  	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
>  
> 


-- 
~Randy
