Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34677 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934152AbdC3TtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 15:49:01 -0400
Received: by mail-wr0-f196.google.com with SMTP id w43so14959841wrb.1
        for <linux-media@vger.kernel.org>; Thu, 30 Mar 2017 12:49:00 -0700 (PDT)
Subject: Re: dvb-tools: dvbv5-scan segfaults with DVB-T2 HD service that just
 started in Germany
To: Frank Heckenbach <f.heckenbach@fh-soft.de>, 859008@bugs.debian.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <E1ctfsO-0006he-Ls@goedel.fjf.gnu.de>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <d0237291-c4c1-915c-af6d-d733812f8ae4@googlemail.com>
Date: Thu, 30 Mar 2017 21:48:57 +0200
MIME-Version: 1.0
In-Reply-To: <E1ctfsO-0006he-Ls@goedel.fjf.gnu.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

could you please take a look?

Thanks,
Gregor

On 3/30/17 9:36 PM, Frank Heckenbach wrote:
> I got the same problem, only on some channels though, e.g. ZDF using
> this input:
> 
> [CH34]
> DELIVERY_SYSTEM = DVBT2
> FREQUENCY = 578000000
> BANDWIDTH_HZ = 8000000
> MODULATION = QAM/16
> 
> *** Error in `dvbv5-scan': malloc(): memory corruption: 0x0000000000fe13c0 ***
> 
> I did some debugging with gdb and valgrind (using the upstream
> version v4l-utils-1.12.3.tar.bz2 since I needed to recompile anyway
> to get debug info).
> 
> I found an invalid access in descriptors/desc_t2_delivery.c:55
> 
>   memcpy(&d->centre_frequency, p, len);
> 
> Before this, dvb_extension_descriptor_init had
> 
>   desc_type == 4 (T2_delivery_system_descriptor)
> 
> and
> 
>   dvb_ext_descriptors[4].size == sizeof(struct dvb_desc_t2_delivery) (23)
> 
> so it allocated only 23 bytes, but didn't change desc_len which was
> still 68, causing the overflow.
> 
> Setting desc_len to 23 didn't help, but just allocating 68 bytes
> did:
> 
> --- v4l-utils-1.12.3/lib/libdvbv5/descriptors/desc_extension.c
> +++ v4l-utils-1.12.3/lib/libdvbv5/descriptors/desc_extension.c
> @@ -149,7 +149,7 @@
>  	if (!size)
>  		size = desc_len;
>  
> -	ext->descriptor = calloc(1, size);
> +	ext->descriptor = calloc(1, desc_len);
>  
>  	if (init) {
>  		if (init(parms, p, ext, ext->descriptor) != 0)
> 
> NOTE: This is probably not a proper fix, just a bandaid. Since
> scanning channels is mostly a one-off job, I'm happy now that I got
> my channels list and don't plan to invest more time resarching the
> issue.
> 
