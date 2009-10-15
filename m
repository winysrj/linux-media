Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1404 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762815AbZJOPge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 11:36:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 1/6 v5] Support for TVP7002 in v4l2 definitions
Date: Thu, 15 Oct 2009 17:35:44 +0200
Cc: santiago.nunez@ridgerun.com, todd.fischer@ridgerun.com,
	linux-media@vger.kernel.org
References: <1255617772-1373-1-git-send-email-santiago.nunez@ridgerun.com>
In-Reply-To: <1255617772-1373-1-git-send-email-santiago.nunez@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151735.44851.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 October 2009 16:42:52 santiago.nunez@ridgerun.com wrote:
> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> 
> This patch provides required chip identification definitions
> within v4l2. Removed HD and control defines.
> 
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  include/media/v4l2-chip-ident.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index cf16689..691cc72 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -129,6 +129,9 @@ enum {
>  	V4L2_IDENT_SAA6752HS = 6752,
>  	V4L2_IDENT_SAA6752HS_AC3 = 6753,
>  
> +	/* module tvp7002: just ident 7002 */
> +	V4L2_IDENT_TVP7002 = 7002,
> +
>  	/* module adv7170: just ident 7170 */
>  	V4L2_IDENT_ADV7170 = 7170,
>  
> @@ -147,6 +150,9 @@ enum {
>  	/* module ths7303: just ident 7303 */
>  	V4L2_IDENT_THS7303 = 7303,
>  
> +	/* module ths7353: just ident 7353 */
> +	V4L2_IDENT_THS7353 = 7353,
> +
>  	/* module adv7343: just ident 7343 */
>  	V4L2_IDENT_ADV7343 = 7343,
>  

Just a small thing: please add 7353 AFTER 7343.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
