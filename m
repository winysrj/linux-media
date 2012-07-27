Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4601 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2G0Gu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 02:50:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [RFC PATCH 2/2] Initial version of RDS Control utility Signed-off-by: Konke Radlow <kradlow@cisco.com>
Date: Fri, 27 Jul 2012 08:50:21 +0200
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <89e7f656fc45f12f2cb5369738b3afd1f712674f.1343237398.git.kradlow@cisco.com> <501196C4.1020909@googlemail.com>
In-Reply-To: <501196C4.1020909@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207270850.21549.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu July 26 2012 21:13:08 Gregor Jasny wrote:
> On 7/25/12 7:44 PM, Konke Radlow wrote:
> 
> > +static void print_rds_af(struct v4l2_rds_af_set *af_set)
> > +{
> > +	int counter = 0;
> > +
> > +	printf("\nAnnounced AFs: %u", af_set->announced_af);
> > +	for (int i = 0; i < af_set->size && i < af_set->announced_af; i++, counter++) {
> > +		if (af_set->af[i] >= 87500000 ) {
> > +			printf("\nAF%02d: %.1fMHz", counter, af_set->af[i] / 1000000.0);
> > +			continue;
> > +		}
> > +		printf("\nAF%02d: %.1fkHz", counter, af_set->af[i] / 1000.0);
> > +	}
> > +}
> > +
> > +static void print_rds_pi(const struct v4l2_rds *handle)
> > +{
> > +	printf("\nArea Coverage: %s", v4l2_rds_get_coverage_str(handle));
> > +}
> > +
> > +static void print_rds_data(struct v4l2_rds *handle, uint32_t updated_fields)
> > +{
> > +	if (params.options[OptPrintBlock])
> > +		updated_fields = 0xFFFFFFFF;
> 
> You could use UINT32_MAX here

I wouldn't. It's a bitmask, not a 'normal' integer and with UINT32_MAX you
lose that connection. The only change I'd make here is to use lower-case for the
hex characters instead of upper case, or perhaps changing it to ~0.

> 
> > +
> > +	if (updated_fields & V4L2_RDS_PI && 
> > +			handle->valid_fields & V4L2_RDS_PI) {
> > +		printf("\nPI: %04x", handle->pi);
> > +		print_rds_pi(handle);
> > +	}
> 
> > +static int parse_cl(int argc, char **argv)
> > +{
> > +	int i = 0;
> > +	int idx = 0;
> > +	int opt = 0;
> > +	char short_options[26 * 2 * 2 + 1];
> 
> Where comes the 26 and 2 from?

Really? Short options are a-z and A-Z. 26? Alphabet? For each option you need
at most two chars (option + an optional argument specifier).

Anyway, I guess a short comment wouldn't hurt.

Note that the option parsing code is all copied from v4l2-ctl and it's used in
a whole bunch of utilities in v4l-utils.

Regards,

	Hans

> Could this be (ARRAY_SIZE(long_options) + 1 ) * 2?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
