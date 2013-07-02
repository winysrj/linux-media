Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36450 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GBS2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 14:28:14 -0400
Received: by mail-ee0-f46.google.com with SMTP id d41so2864470eek.19
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 11:28:12 -0700 (PDT)
Received: from myon.exnihilo (51-213.60-188.cust.bluewin.ch. [188.60.213.51])
        by mx.google.com with ESMTPSA id b3sm38131451eev.10.2013.07.02.11.28.11
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 02 Jul 2013 11:28:12 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:28:09 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/6] libdvbv5: Remove buggy parsing of extra DTV_foo
 parameters
Message-ID: <20130702202809.67b62207@myon.exnihilo>
In-Reply-To: <a386f3a8a7b76795dc487f9ae6ec728628c5bc0a.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
	<a386f3a8a7b76795dc487f9ae6ec728628c5bc0a.1371561676.git.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: André Roth <neolynx@gmail.com>


On Tue, 18 Jun 2013 16:19:04 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:

> The parsing of those extra parameters is buggy and completely useless since they are parsed
> individually later on in the code.
> 
> Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
> ---
>  lib/libdvbv5/dvb-file.c | 25 -------------------------
>  1 file changed, 25 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index d8d583c..aa42a37 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -392,31 +392,6 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
>  		return 0;
>  	}
>  
> -	/* Handle the DVB extra DTV_foo properties */
> -	for (i = 0; i < ARRAY_SIZE(dvb_user_name); i++) {
> -		if (!dvb_user_name[i])
> -			continue;
> -		if (!strcasecmp(key, dvb_user_name[i]))
> -			break;
> -	}
> -	if (i < ARRAY_SIZE(dvb_user_name)) {
> -		const char * const *attr_name = dvb_attr_names(i);
> -		n_prop = entry->n_props;
> -		entry->props[n_prop].cmd = i + DTV_USER_COMMAND_START;
> -		if (!attr_name || !*attr_name)
> -			entry->props[n_prop].u.data = atol(value);
> -		else {
> -			for (j = 0; attr_name[j]; j++)
> -				if (!strcasecmp(value, attr_name[j]))
> -					break;
> -			if (!attr_name[j])
> -				return -2;
> -			entry->props[n_prop].u.data = j + DTV_USER_COMMAND_START;
> -		}
> -		entry->n_props++;
> -		return 0;
> -	}
> -
>  	/* Handle the other properties */
>  
>  	if (!strcasecmp(key, "SERVICE_ID")) {
