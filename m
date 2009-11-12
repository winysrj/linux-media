Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4493 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZKLHPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:15:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?iso-8859-2?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] decode_tm6000: fix include path
Date: Thu, 12 Nov 2009 08:15:03 +0100
Cc: V4L Mailing List <linux-media@vger.kernel.org>
References: <4AFBB0C3.8000509@freemail.hu>
In-Reply-To: <4AFBB0C3.8000509@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911120815.03113.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 12 November 2009 07:52:51 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The include path is changed from ../lib to ../lib4vl2util .
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r 60f784aa071d v4l2-apps/util/decode_tm6000.c
> --- a/v4l2-apps/util/decode_tm6000.c	Wed Nov 11 18:28:53 2009 +0100
> +++ b/v4l2-apps/util/decode_tm6000.c	Thu Nov 12 07:49:43 2009 +0100
> @@ -16,7 +16,7 @@
>     along with this program; if not, write to the Free Software
>     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
> -#include "../lib/v4l2_driver.h"
> +#include "../libv4l2util/v4l2_driver.h"
>  #include <stdio.h>
>  #include <string.h>
>  #include <argp.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

This is already part of my pull request from Monday. So this will hopefully be
merged soon.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
