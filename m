Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39167 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2GZTCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 15:02:07 -0400
Received: by bkwj10 with SMTP id j10so1469399bkw.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 12:02:06 -0700 (PDT)
Message-ID: <5011942A.9020300@googlemail.com>
Date: Thu, 26 Jul 2012 21:02:02 +0200
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
> --- /dev/null
> +++ b/utils/rds-ctl/rds-ctl.cpp
> @@ -0,0 +1,978 @@
> +/*
> + * rds-ctl.cpp is based on v4l2-ctl.cpp
> + * 
> + * the following applies for all RDS related parts:
> + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + * Author: Konke Radlow <koradlow@gmail.com>
> + * 
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License as published by
> + * the Free Software Foundation; either version 2.1 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
> + */
> +
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <wchar.h>
> +#include <locale.h>
> +#include <inttypes.h>
> +#include <getopt.h>
> +#include <sys/types.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <sys/ioctl.h>
> +#include <sys/time.h>
> +#include <dirent.h>
> +#include <config.h>
> +#include <signal.h>
> +
> +#ifdef HAVE_SYS_KLOG_H
> +#include <sys/klog.h>
> +#endif

You don't call klog, so you can drop these three lines

> +static int parse_cl(int argc, char **argv)
> +{
> +	int i = 0;
> +	int idx = 0;
> +	int opt = 0;
> +	char short_options[26 * 2 * 2 + 1];
> +
> +	if (argc == 1) {
> +		usage_hint();
> +		exit(1);
> +	}
> +	for (i = 0; long_options[i].name; i++) {
> +		if (!isalpha(long_options[i].val))
> +			continue;
> +		short_options[idx++] = long_options[i].val;
> +		if (long_options[i].has_arg == required_argument)
> +			short_options[idx++] = ':';
> +	}
> +	while (1) {
> +		// TODO: remove option_index ?
> +		int option_index = 0;
> +
> +		short_options[idx] = 0;
> +		opt = getopt_long(argc, argv, short_options,
> +				 long_options, &option_index);
> +		if (opt == -1)
> +			break;
> +
> +		params.options[(int)opt] = 1;
> +		switch (opt) {
> +		case OptSetDevice:
> +			strncpy(params.fd_name, optarg, 80);
> +			if (optarg[0] >= '0' && optarg[0] <= '9' && optarg[1] == 0) {

see isdigit from <types.h> (or std::isdigit from <ctypes>)


Thanks,
Gregor
