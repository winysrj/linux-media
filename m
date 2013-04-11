Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59588 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab3DKS2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <201304112024.06542.hverkuil@xs4all.nl>
References: <20130410114051.GA21419@longonot.mountain>
	<201304112024.06542.hverkuil@xs4all.nl>
Date: Thu, 11 Apr 2013 11:28:16 -0700
Message-ID: <CAHQ1cqEkN=wa-iaujbcG-AtsK2NWifMqgCed-2aVqy7b7rW5LQ@mail.gmail.com>
Subject: Re: [patch] [media] radio-si476x: check different function pointers
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 11, 2013 at 11:24 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed April 10 2013 13:40:51 Dan Carpenter wrote:
>> This is a static checker where it complains if we check for one function
>> pointer and then call a different function on the next line.
>>
>> In most cases, the code does the same thing before and after this patch.
>> For example, when ->phase_diversity is non-NULL then ->phase_div_status
>> is also non-NULL.
>>
>> The one place where that's not true is when we check ->rds_blckcnt
>> instead of ->rsq_status.  In those cases, we would want to call
>> ->rsq_status but we instead return -ENOENT.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> Please review this carefully.  I don't have the hardware to test it.
>
> Andrey, can you review this? I think the first two chunks are correct, but
> the last two chunks are probably not what you want. In the case of an AM
> receiver there is no RDS data, so an error is probably correct.
>

Sorry, I suck at gmail-ing and my response to this letter was bounced
for having HTML in it and I guess you didn't receive it either, I'll
just copy it below:

====================================

On Wed, Apr 10, 2013 at 4:40 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> This is a static checker where it complains if we check for one function
> pointer and then call a different function on the next line.
>
> In most cases, the code does the same thing before and after this patch.
> For example, when ->phase_diversity is non-NULL then ->phase_div_status
> is also non-NULL.
>
> The one place where that's not true is when we check ->rds_blckcnt
> instead of ->rsq_status.  In those cases, we would want to call
> ->rsq_status but we instead return -ENOENT.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Please review this carefully.  I don't have the hardware to test it.
>
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> index 9430c6a..817fc0c 100644
> --- a/drivers/media/radio/radio-si476x.c
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -854,7 +854,7 @@ static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>         switch (ctrl->id) {
>         case V4L2_CID_SI476X_INTERCHIP_LINK:
>                 if (si476x_core_has_diversity(radio->core)) {
> -                       if (radio->ops->phase_diversity) {
> +                       if (radio->ops->phase_div_status) {
>                                 retval = radio->ops->phase_div_status(radio->core);
>                                 if (retval < 0)
>                                         break;

I think I would prefer to use "si476x_core_is_in_am_receiver_mode" in
the case above and then have additional
BUG_ON(radio->ops->phase_div_status) for cases where it should not be
NULL(tuner in FM mode, diversity feature present) also I probably
should return -EINVAL in all the cases for this control.



> @@ -1285,7 +1285,7 @@ static ssize_t si476x_radio_read_agc_blob(struct file *file,
>         struct si476x_agc_status_report report;
>
>         si476x_core_lock(radio->core);
> -       if (radio->ops->rds_blckcnt)
> +       if (radio->ops->agc_status)
>                 err = radio->ops->agc_status(radio->core, &report);
>         else
>                 err = -ENOENT;
> @@ -1320,7 +1320,7 @@ static ssize_t si476x_radio_read_rsq_blob(struct file *file,
>         };
>
>         si476x_core_lock(radio->core);
> -       if (radio->ops->rds_blckcnt)
> +       if (radio->ops->rsq_status)
>                 err = radio->ops->rsq_status(radio->core, &args, &report);
>         else
>                 err = -ENOENT;
> @@ -1355,7 +1355,7 @@ static ssize_t si476x_radio_read_rsq_primary_blob(struct file *file,
>         };
>
>         si476x_core_lock(radio->core);
> -       if (radio->ops->rds_blckcnt)
> +       if (radio->ops->rsq_status)
>                 err = radio->ops->rsq_status(radio->core, &args, &report);
>         else
>                 err = -ENOENT;

This all looks like a dumb copy-paste screw up on my part. I think I
copied the body of "si476x_radio_read_rds_blckcnt_blob" and used it to
implement all the other functions and I guess forgot to change this
bit of the code. Thank you for catching this, mistakes like this are
just embarrassing.

I'll make a patch based on this one and send it alongside the patches
for MFD subsystem
