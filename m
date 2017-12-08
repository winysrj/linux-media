Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752350AbdLHWHw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 17:07:52 -0500
Subject: Re: [PATCH v2] kernel-doc: parse DECLARE_KFIFO and
 DECLARE_KFIFO_PTR()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
References: <37a81ae259c9d3a90fbdbe1532f904946139bfdd.1512741889.git.mchehab@s-opensource.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3b83c0e0-4bd7-a2ad-c667-eb40987f84e2@infradead.org>
Date: Fri, 8 Dec 2017 14:07:51 -0800
MIME-Version: 1.0
In-Reply-To: <37a81ae259c9d3a90fbdbe1532f904946139bfdd.1512741889.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2017 06:05 AM, Mauro Carvalho Chehab wrote:
> On media, we now have an struct declared with:
> 
> struct lirc_fh {
>         struct list_head list;
>         struct rc_dev *rc;
>         int                             carrier_low;
>         bool                            send_timeout_reports;
>         DECLARE_KFIFO_PTR(rawir, unsigned int);
>         DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
>         wait_queue_head_t               wait_poll;
>         u8                              send_mode;
>         u8                              rec_mode;
> };
> 
> gpiolib.c has a similar declaration with DECLARE_KFIFO().
> 
> Currently, those produce the following error:
> 
> 	./include/media/rc-core.h:96: warning: No description found for parameter 'int'
> 	./include/media/rc-core.h:96: warning: No description found for parameter 'lirc_scancode'
> 	./include/media/rc-core.h:96: warning: Excess struct member 'rawir' description in 'lirc_fh'
> 	./include/media/rc-core.h:96: warning: Excess struct member 'scancodes' description in 'lirc_fh'
> 	../drivers/gpio/gpiolib.c:601: warning: No description found for parameter '16'
> 	../drivers/gpio/gpiolib.c:601: warning: Excess struct member 'events' description in 'lineevent_state'
> 
> So, teach kernel-doc how to parse DECLARE_KFIFO() and DECLARE_KFIFO_PTR().
> 
> While here, relax at the past DECLARE_foo() macros, accepting a random
> number of spaces after comma.
> 
> The addition of DECLARE_KFIFO() was
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  scripts/kernel-doc | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index bd29a92b4b48..cfdabdd08631 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2208,9 +2208,13 @@ sub dump_struct($$) {
>  	$members =~ s/__aligned\s*\([^;]*\)//gos;
>  	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
>  	# replace DECLARE_BITMAP
> -	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
> +	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
>  	# replace DECLARE_HASHTABLE
> -	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> +	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> +	# replace DECLARE_KFIFO
> +	$members =~ s/DECLARE_KFIFO\s*\(([^,)]+),\s*([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
> +	# replace DECLARE_KFIFO_PTR
> +	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
>  
>  	create_parameterlist($members, ';', $file);
>  	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
> 


-- 
~Randy
