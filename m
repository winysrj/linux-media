Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4243 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3EJLjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 07:39:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Konke Radlow <koradlow@gmail.com>
Subject: Re: [RFC PATCH 2/4] rds-ctl.cpp: added functionality to print RDS-EON information
Date: Fri, 10 May 2013 13:39:01 +0200
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
References: <1367943863-28803-1-git-send-email-koradlow@gmail.com> <63291557e0c1b342aea66fc33ef900cf22051db3.1367943797.git.koradlow@gmail.com>
In-Reply-To: <63291557e0c1b342aea66fc33ef900cf22051db3.1367943797.git.koradlow@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101339.01805.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 7 2013 18:24:21 Konke Radlow wrote:
> Signed-off-by: Konke Radlow <koradlow@gmail.com>
> ---
>  utils/rds-ctl/rds-ctl.cpp |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
> index de76d9f..51536cf 100644
> --- a/utils/rds-ctl/rds-ctl.cpp
> +++ b/utils/rds-ctl/rds-ctl.cpp
> @@ -550,6 +550,33 @@ static void print_rds_af(const struct v4l2_rds_af_set *af_set)
>  	}
>  }
>  
> +static void print_rds_eon(const struct v4l2_rds_eon_set *eon_set)
> +{
> +	int counter = 0;
> +
> +	printf("\n\nEnhanced Other Network information: %u channels", eon_set->size);
> +	for (int i = 0; i < eon_set->size; i++, counter++) {
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_PI)
> +			printf("\nPI(ON %02i) =  %04x", i, eon_set->eon[i].pi);
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_PS)
> +			printf("\nPS(ON %02i) =  %s", i, eon_set->eon[i].ps);
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_PTY)
> +			printf("\nPTY(ON %02i) =  %0u", i, eon_set->eon[i].pty);
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_LSF)
> +			printf("\nLSF(ON %02i) =  %0u", i, eon_set->eon[i].lsf);
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_AF)
> +			printf("\nPTY(ON %02i) =  %0u", i, eon_set->eon[i].pty);
> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_TP)
> +			printf("\nTP(ON %02i): %s" ,i ,eon_set->eon[i].tp? "yes":"no");

Spacing is a bit messy. This is better:

			printf("\nTP(ON %02i): %s", i, eon_set->eon[i].tp ? "yes" : "no");

> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_TA)
> +			printf("\nTA(ON %02i): %s",i ,eon_set->eon[i].tp? "yes":"no");

Ditto:
			printf("\nTA(ON %02i): %s", i, eon_set->eon[i].tp ? "yes" : "no");

> +		if (eon_set->eon[i].valid_fields & V4L2_RDS_AF) {
> +			printf("\nAF(ON %02i): size=%i", i, eon_set->eon[i].af.size);
> +			print_rds_af(&(eon_set->eon[i].af));
> +		}
> +	}
> +}
> +
>  static void print_rds_pi(const struct v4l2_rds *handle)
>  {
>  	printf("\nArea Coverage: %s", v4l2_rds_get_coverage_str(handle));
> @@ -662,6 +689,8 @@ static void read_rds_from_fd(const int fd)
>  
>  	/* try to receive and decode RDS data */
>  	read_rds(rds_handle, fd, params.wait_limit);
> +	if (rds_handle->valid_fields & V4L2_RDS_EON)
> +		print_rds_eon(&rds_handle->rds_eon);
>  	print_rds_statistics(&rds_handle->rds_statistics);
>  
>  	v4l2_rds_destroy(rds_handle);
> 

Regards,

	Hans
