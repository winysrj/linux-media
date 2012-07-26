Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41274 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2GZTNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 15:13:13 -0400
Received: by bkwj10 with SMTP id j10so1475181bkw.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 12:13:12 -0700 (PDT)
Message-ID: <501196C4.1020909@googlemail.com>
Date: Thu, 26 Jul 2012 21:13:08 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] Initial version of RDS Control utility Signed-off-by:
 Konke Radlow <kradlow@cisco.com>
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <89e7f656fc45f12f2cb5369738b3afd1f712674f.1343237398.git.kradlow@cisco.com>
In-Reply-To: <89e7f656fc45f12f2cb5369738b3afd1f712674f.1343237398.git.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/25/12 7:44 PM, Konke Radlow wrote:

> +static void print_rds_af(struct v4l2_rds_af_set *af_set)
> +{
> +	int counter = 0;
> +
> +	printf("\nAnnounced AFs: %u", af_set->announced_af);
> +	for (int i = 0; i < af_set->size && i < af_set->announced_af; i++, counter++) {
> +		if (af_set->af[i] >= 87500000 ) {
> +			printf("\nAF%02d: %.1fMHz", counter, af_set->af[i] / 1000000.0);
> +			continue;
> +		}
> +		printf("\nAF%02d: %.1fkHz", counter, af_set->af[i] / 1000.0);
> +	}
> +}
> +
> +static void print_rds_pi(const struct v4l2_rds *handle)
> +{
> +	printf("\nArea Coverage: %s", v4l2_rds_get_coverage_str(handle));
> +}
> +
> +static void print_rds_data(struct v4l2_rds *handle, uint32_t updated_fields)
> +{
> +	if (params.options[OptPrintBlock])
> +		updated_fields = 0xFFFFFFFF;

You could use UINT32_MAX here

> +
> +	if (updated_fields & V4L2_RDS_PI && 
> +			handle->valid_fields & V4L2_RDS_PI) {
> +		printf("\nPI: %04x", handle->pi);
> +		print_rds_pi(handle);
> +	}

> +static int parse_cl(int argc, char **argv)
> +{
> +	int i = 0;
> +	int idx = 0;
> +	int opt = 0;
> +	char short_options[26 * 2 * 2 + 1];

Where comes the 26 and 2 from?
Could this be (ARRAY_SIZE(long_options) + 1 ) * 2?

