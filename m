Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab3AHMdk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 07:33:40 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r08CXeH5022121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 8 Jan 2013 07:33:40 -0500
Date: Tue, 8 Jan 2013 10:33:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties for Quality
 of Service
Message-ID: <20130108103308.47562c31@redhat.com>
In-Reply-To: <1357604750-772-2-git-send-email-mchehab@redhat.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com>
	<1357604750-772-2-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  7 Jan 2013 22:25:47 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> The DVBv3 quality parameters are limited on several ways:
> 
>         - Doesn't provide any way to indicate the used measure,
> 	  so userspace need to guess how to calculate the measure;
> 
>         - Only a limited set of stats are supported;
> 
>         - Can't be called in a way to require them to be filled
>           all at once (atomic reads from the hardware), with may
>           cause troubles on interpreting them on userspace;
> 
>         - On some OFDM delivery systems, the carriers can be
>           independently modulated, having different properties.
>           Currently, there's no way to report per-layer stats.
> 
> To address the above issues, adding a new DVBv5-based stats
> API.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 

...

> +struct dtv_stats {
> +	__u8 scale;	/* enum fecap_scale_params type */
> +	union {
> +		__u32 uvalue;	/* for counters and relative scales */
> +		__s32 svalue;	/* for 0.1 dB measures */

32 bits for total bit count is not enough, as it can be truncated too
early (~1 seg on ISDB-T, ~0.5 seg on DVB-C). I think we need to use
64 bits here, and put at the API that the drivers should monotonically
increment.

As struct buffer inside struct dtv_property has 48 bytes, we can do such
change here without breaking userspace, as struct dtv_stats will have
37 bytes.

-- 

Cheers,
Mauro
