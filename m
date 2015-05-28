Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42848 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbbE1V6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:58:08 -0400
Message-ID: <55678F64.6080801@xs4all.nl>
Date: Thu, 28 May 2015 23:57:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 07/35] dvb: split enum from typedefs at frontend.h
References: <cover.1432844837.git.mchehab@osg.samsung.com> <6576f479a6e2449132811f5681e35d3794110d25.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <6576f479a6e2449132811f5681e35d3794110d25.1432844837.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2015 11:49 PM, Mauro Carvalho Chehab wrote:
> Using typedefs is already bad enough, but doing it together
> with enum declaration is even worse.
> 
> Also, it breaks the scripts at DocBook that would be generating
> reference pointers for the enums.
> 
> Well, we can't get rid of typedef right now, but let's at least
> declare it on a separate line, and let the scripts to generate
> the cross-reference, as this is needed for the next DocBook
> patches.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 466f56997272..7aeeb5a69fdf 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -36,7 +36,7 @@ typedef enum fe_type {
>  } fe_type_t;
>  
>  
> -typedef enum fe_caps {
> +enum fe_caps {
>  	FE_IS_STUPID			= 0,
>  	FE_CAN_INVERSION_AUTO		= 0x1,
>  	FE_CAN_FEC_1_2			= 0x2,
> @@ -68,7 +68,9 @@ typedef enum fe_caps {
>  	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
>  	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
>  	FE_CAN_MUTE_TS			= 0x80000000  /* frontend can stop spurious TS data output */
> -} fe_caps_t;
> +};
> +
> +typedef enum fe_caps_t;

This can't be right. This should be:

typedef enum fe_caps fe_caps_t;

Does it even compile?

Regards,

	Hans

>  
>  
>  struct dvb_frontend_info {
> @@ -134,7 +136,7 @@ typedef enum fe_sec_mini_cmd {
>   *			to reset DiSEqC, tone and parameters
>   */
>  
> -typedef enum fe_status {
> +enum fe_status {
>  	FE_HAS_SIGNAL		= 0x01,
>  	FE_HAS_CARRIER		= 0x02,
>  	FE_HAS_VITERBI		= 0x04,
> @@ -142,7 +144,9 @@ typedef enum fe_status {
>  	FE_HAS_LOCK		= 0x10,
>  	FE_TIMEDOUT		= 0x20,
>  	FE_REINIT		= 0x40,
> -} fe_status_t;
> +};
> +
> +typedef enum fe_status fe_status_t;
>  
>  typedef enum fe_spectral_inversion {
>  	INVERSION_OFF,
> 

