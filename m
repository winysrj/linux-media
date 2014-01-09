Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62885 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAITj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 14:39:59 -0500
Received: by mail-bk0-f45.google.com with SMTP id mx13so1279338bkb.18
        for <linux-media@vger.kernel.org>; Thu, 09 Jan 2014 11:39:58 -0800 (PST)
Message-ID: <52CEFB09.3070307@googlemail.com>
Date: Thu, 09 Jan 2014 20:39:53 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIFJvdGg=?= <neolynx@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] libdvbv5: implement MGT table parser
References: <1389180208-3458-1-git-send-email-neolynx@gmail.com> <1389180208-3458-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1389180208-3458-2-git-send-email-neolynx@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello André,

On 08/01/14 12:23, André Roth wrote:
> ...
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +			uint16_t pid:13;
> +			uint16_t one:3;
> +		} __attribute__((packed));
> +	} __attribute__((packed));
> +        uint8_t type_version:5;
> +        uint8_t one2:3;
> +        uint32_t size;

Are you sure that this code handles the endianess correctly? Looking at 
netinet/in.h I'm under the impression that the order of the bitfield 
entries have to be swapped, too:

struct ip
   {
#if __BYTE_ORDER == __LITTLE_ENDIAN
     unsigned int ip_hl:4;               /* header length */
     unsigned int ip_v:4;                /* version */
#endif
#if __BYTE_ORDER == __BIG_ENDIAN
     unsigned int ip_v:4;                /* version */
     unsigned int ip_hl:4;               /* header length */
#endif

I also remember that you can also easily get the byte swapping wrongif 
entries cross byte borders (like a :13 one).

Maybe you could write some unit tests for your functions. The Debian 
build farm then will catch any errors.

Cheers,
Gregor
