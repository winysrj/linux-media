Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38830 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0EKJda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 05:33:30 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 11 May 2010 15:03:22 +0530
Subject: RE: [PATCH 1/6] [RFC] tvp514x: do NOT change the std as a side
 effect
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404BD5@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
 <f8a23c5d53950c0d637837d4f11cba8946679c5d.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <f8a23c5d53950c0d637837d4f11cba8946679c5d.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 1/6] [RFC] tvp514x: do NOT change the std as a side effect
> 
> Several calls (try_fmt, g_parm among others) changed the current standard
> as a side effect of that call. But the standard may only be changed by
> s_std.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/tvp514x.c |   53 ++++++++++++--------------------------
> --
>  1 files changed, 16 insertions(+), 37 deletions(-)
> 
<snip>
> -	decoder->current_std = current_std;
> +	current_std = decoder->current_std;
> 
>  	*timeperframe =
>  	    decoder->std_list[current_std].standard.frameperiod;
> --
> 1.6.4.2

[Hiremath, Vaibhav] Looks ok to me. I have tested it on AM3517EVM platform.


Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav

