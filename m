Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50185 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab0ANRHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 12:07:24 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Michael Trimarchi <michael@panicking.kicks-ass.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 14 Jan 2010 11:09:46 -0600
Subject: RE: omap34xxcam question?
Message-ID: <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com>
References: <4B4F0762.4040007@panicking.kicks-ass.org>
In-Reply-To: <4B4F0762.4040007@panicking.kicks-ass.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
> Sent: Thursday, January 14, 2010 6:01 AM
> To: linux-media@vger.kernel.org
> Cc: Aguirre, Sergio
> Subject: omap34xxcam question?
> 
> Hi
> 
> Is ok that it try only the first format and size? why does it not continue
> and find a matching?

Actually, that was the intention, but I guess it was badly implemented.

Thanks for the catch, and the contribution!

Regards,
Sergio
> 
> @@ -470,7 +471,7 @@ static int try_pix_parm(struct omap34xxcam_videodev
> *vdev,
>                         pix_tmp_out = *wanted_pix_out;
>                         rval = isp_try_fmt_cap(isp, &pix_tmp_in,
> &pix_tmp_out);
>                         if (rval)
> -                               return rval;
> +                               continue;
> 
> Michael
