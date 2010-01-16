Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54032 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab0APSuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 13:50:13 -0500
Subject: Re: [PATCH] disable building cx23885 before 2.6.33
From: Andy Walls <awalls@radix.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B51E313.4060102@freemail.hu>
References: <201001141910.o0EJARf7029441@smtp-vbr14.xs4all.nl>
	 <4B4F7D14.7080806@freemail.hu>
	 <201001150236.25297.laurent.pinchart@ideasonboard.com>
	 <4B51E313.4060102@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 13:49:24 -0500
Message-Id: <1263667764.1704.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-01-16 at 17:02 +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The cx23885 driver does not compile before Linux kernel 2.6.33 because of
> incompatible fifo API changes. Disable this driver being built before
> 2.6.33.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Nak.

1. You forgot meye - it's broken as well in the same way.
2. Douglas has issuesd a PULL request for a back port fix that will
resolve the issue.

Regards,
Andy

> ---
> diff -r 5bcdcc072b6d v4l/versions.txt
> --- a/v4l/versions.txt	Sat Jan 16 07:25:43 2010 +0100
> +++ b/v4l/versions.txt	Sat Jan 16 16:56:28 2010 +0100
> @@ -1,6 +1,10 @@
>  # Use this for stuff for drivers that don't compile
>  [2.6.99]
> 
> +[2.6.33]
> +# Incompatible fifo API changes, see <linux/kfifo.h>
> +VIDEO_CX23885
> +
>  [2.6.32]
>  # These rely on arch support that wasn't available until 2.6.32
>  VIDEO_SH_MOBILE_CEU
> 


