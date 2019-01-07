Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49948C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAB62087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 10:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfAGKTF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 05:19:05 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43482 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbfAGKTF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 05:19:05 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gRzmgESr9BDyIgRzqgN5bV; Mon, 07 Jan 2019 11:19:02 +0100
Subject: Re: [RFC PATCH 5/5] v4l2-ctl: add an option to list controls in a
 machine-readable format
To:     Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it> <20190103180102.12282-6-ao2@ao2.it>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3f081956-7733-069b-da24-0d04831b8ed1@xs4all.nl>
Date:   Mon, 7 Jan 2019 11:18:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190103180102.12282-6-ao2@ao2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfA0NPnfpnsHdQnOsWqYhnIfGqDCnrLOslUBCLSN1xBxNOj1bX33rRiTxAcbAa2NBbuOvFZxk1sRT66fHjaR3Rd+EUBIO3r2okPq9S7VUXbA/nyXp/rXu
 xn/qI7EGRa6Ch04SW6pnwewTog6cn0eNKTPKFz4PUX7Ze3OQg5CFjmskT5S8hXE5kxjB2+FadZ7xleMa+oPQiIZ72MsXaGZXeT0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/03/2019 07:01 PM, Antonio Ospite wrote:
> Add a new option --list-ctrls-values to list the values of controls in
> a format which can be passed again to --set-ctrl.
> 
> This can be useful to save and restore device settings:
> 
>   $ v4l2-ctl --list-ctrls-values >settings.txt 2>/dev/null
>   $ v4l2-ctl --set-ctrl "$(cat settings.txt)"
> 
> The new option has been tested with the vivid driver and it works well
> enough to be useful with a real driver as well.
> 
> String controls are not supported for now, as they may not be parsed
> correctly by --set-ctrl if they contain a comma or a single quote.
> 
> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> ---
>  utils/v4l2-ctl/v4l2-ctl-common.cpp | 72 ++++++++++++++++++++++++++----
>  utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
>  utils/v4l2-ctl/v4l2-ctl.cpp        |  1 +
>  utils/v4l2-ctl/v4l2-ctl.h          |  1 +
>  4 files changed, 69 insertions(+), 9 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> index 7777b45c..b4124608 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> @@ -93,6 +93,9 @@ void common_usage(void)
>  	       "  -l, --list-ctrls   display all controls and their values [VIDIOC_QUERYCTRL]\n"
>  	       "  -L, --list-ctrls-menus\n"
>  	       "		     display all controls and their menus [VIDIOC_QUERYMENU]\n"
> +	       "  -m, --list-ctrls-values\n"
> +	       "		     display all controls and their values in a format compatible with\n"
> +	       "		     --set-ctrls (the 'm' stands for \"machine readable output\")\n"
>  	       "  -r, --subset <ctrl>[,<offset>,<size>]+\n"
>  	       "                     the subset of the N-dimensional array to get/set for control <ctrl>,\n"
>  	       "                     for every dimension an (<offset>, <size>) tuple is given.\n"
> @@ -409,6 +412,46 @@ static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
>  	}
>  }
>  
> +static void print_qctrl_values(int fd, struct v4l2_query_ext_ctrl *queryctrl,
> +		struct v4l2_ext_control *ctrl, int show_menus)
> +{
> +	std::string s = name2var(queryctrl->name);
> +
> +	if (queryctrl->nr_of_dims == 0) {
> +		switch (queryctrl->type) {
> +		case V4L2_CTRL_TYPE_INTEGER:
> +		case V4L2_CTRL_TYPE_BOOLEAN:
> +		case V4L2_CTRL_TYPE_MENU:
> +		case V4L2_CTRL_TYPE_INTEGER_MENU:
> +			printf("%s=%d,", s.c_str(), ctrl->value);
> +			break;
> +		case V4L2_CTRL_TYPE_BITMASK:
> +			printf("%s=0x%08x,", s.c_str(), ctrl->value);
> +			break;
> +		case V4L2_CTRL_TYPE_INTEGER64:
> +			printf("%s=%lld,", s.c_str(), ctrl->value64);
> +			break;
> +		case V4L2_CTRL_TYPE_STRING:
> +			fprintf(stderr, "%s: string controls unsupported for now\n", queryctrl->name);
> +			break;
> +		default:
> +			fprintf(stderr, "%s: unsupported payload type\n", queryctrl->name);
> +			break;
> +		}
> +	}
> +
> +	if (queryctrl->nr_of_dims)
> +		fprintf(stderr, "%s: unsupported payload type (multi-dimensional)\n", queryctrl->name);
> +
> +	if (queryctrl->flags)
> +		fprintf(stderr, "%s: ignoring flags\n", queryctrl->name);
> +
> +	if ((queryctrl->type == V4L2_CTRL_TYPE_MENU ||
> +	     queryctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU) && show_menus) {
> +		fprintf(stderr, "%s: ignoring menus\n", queryctrl->name);
> +	}
> +}
> +
>  static void print_class_name(const char *name)
>  {
>  	printf("\n%s\n\n", name);
> @@ -426,7 +469,8 @@ static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, struct print
>  	if (qctrl.flags & V4L2_CTRL_FLAG_DISABLED)
>  		return 1;
>  	if (qctrl.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
> -		format->print_class_name(qctrl.name);
> +		if (format->print_class_name)
> +			format->print_class_name(qctrl.name);
>  		return 1;
>  	}
>  	ext_ctrl.id = qctrl.id;
> @@ -1102,13 +1146,23 @@ void common_get(cv4l_fd &_fd)
>  
>  void common_list(cv4l_fd &fd)
>  {
> -	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
> -		struct print_format classic_format = {
> -			.print_class_name = print_class_name,
> -			.print_qctrl = print_qctrl,
> -			.show_menus = options[OptListCtrlsMenus],
> -		};
> -
> -		list_controls(fd.g_fd(), &classic_format);
> +	if (options[OptListCtrls] || options[OptListCtrlsMenus] || options[OptListCtrlsValues]) {
> +		if (options[OptListCtrlsValues]) {
> +			struct print_format machine_format = {
> +				.print_class_name = NULL,
> +				.print_qctrl = print_qctrl_values,
> +				.show_menus = 0,
> +			};
> +
> +			list_controls(fd.g_fd(), &machine_format);
> +		} else {
> +			struct print_format classic_format = {
> +				.print_class_name = print_class_name,
> +				.print_qctrl = print_qctrl,
> +				.show_menus = options[OptListCtrlsMenus],
> +			};
> +
> +			list_controls(fd.g_fd(), &classic_format);
> +		}

I don't like this struct print_format.

I would prefer something like this:

Rename print_qctrl to print_qctrl_readable() and create a new print_qctrl:

static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
                struct v4l2_ext_control *ctrl, int show_menus)
{
	if (options[OptListCtrlsValues])
		print_qctrl_values(fd, queryctrl, ctrl, show_menus);
	else
		print_qctrl_readable(fd, queryctrl, ctrl, show_menus);
}

And in print_control you can just skip printing the class name if
options[OptListCtrlsValues] is set.

I would like to see string controls being supported. I would recommend
to just write the string as a hexdump. It avoids having to escape characters.

The same can be done for compound/array controls. In fact, you could write
all controls that way. It would simplify things a lot.

Also, when options[OptListCtrlsValues] is set you should skip all WRITE_ONLY
controls, all BUTTON controls, and all volatile controls. They are not
relevant if you are just interested in controls that can be set.

Regards,

	Hans

>  	}
>  }
> diff --git a/utils/v4l2-ctl/v4l2-ctl.1.in b/utils/v4l2-ctl/v4l2-ctl.1.in
> index e60c2d49..98cc7b72 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.1.in
> +++ b/utils/v4l2-ctl/v4l2-ctl.1.in
> @@ -98,6 +98,10 @@ Display all controls and their values [VIDIOC_QUERYCTRL].
>  \fB-L\fR, \fB--list-ctrls-menus\fR
>  Display all controls and their menus [VIDIOC_QUERYMENU].
>  .TP
> +\fB-m\fR, \fB--list-ctrls-values\fR
> +display all controls and their values in a format compatible with
> +--set-ctrls (the 'm' stands for "machine readable output")
> +.TP
>  \fB-r\fR, \fB--subset\fR \fI<ctrl>\fR[,\fI<offset>\fR,\fI<size>\fR]+
>  The subset of the N-dimensional array to get/set for control \fI<ctrl>\fR,
>  for every dimension an (\fI<offset>\fR, \fI<size>\fR) tuple is given.
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index a65262f6..647e1778 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -142,6 +142,7 @@ static struct option long_options[] = {
>  	{"info", no_argument, 0, OptGetDriverInfo},
>  	{"list-ctrls", no_argument, 0, OptListCtrls},
>  	{"list-ctrls-menus", no_argument, 0, OptListCtrlsMenus},
> +	{"list-ctrls-values", no_argument, 0, OptListCtrlsValues},
>  	{"set-ctrl", required_argument, 0, OptSetCtrl},
>  	{"get-ctrl", required_argument, 0, OptGetCtrl},
>  	{"get-tuner", no_argument, 0, OptGetTuner},
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 5a52a0a4..e60a1ea1 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -65,6 +65,7 @@ enum Option {
>  	OptConcise = 'k',
>  	OptListCtrls = 'l',
>  	OptListCtrlsMenus = 'L',
> +	OptListCtrlsValues = 'm',
>  	OptListOutputs = 'N',
>  	OptListInputs = 'n',
>  	OptGetOutput = 'O',
> 

