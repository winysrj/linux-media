Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:52204 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbZIUEAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 00:00:10 -0400
Subject: Re: Bug in S2 API...
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 05:46:45 +0200
Message-Id: <1253504805.3255.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 21.09.2009, 05:40 +0200 schrieb Markus Rechberger:
> while porting the S2api to userspace I came accross the S2-API definition itself
> 
> #define FE_SET_PROPERTY            _IOW('o', 82, struct dtv_properties)
> #define FE_GET_PROPERTY            _IOR('o', 83, struct dtv_properties)
> 
> while looking at this, FE_GET_PROPERTY should very likely be _IOWR
> 
> in dvb-frontend.c:
> ----
>         if(cmd == FE_GET_PROPERTY) {
> 
>                 tvps = (struct dtv_properties __user *)parg;
> 
>                 dprintk("%s() properties.num = %d\n", __func__, tvps->num);
>                 dprintk("%s() properties.props = %p\n", __func__, tvps->props);
>                 ...
>                 if (copy_from_user(tvp, tvps->props, tvps->num *
> sizeof(struct dtv_property)))
> ----
> 
> Regards,
> Markus

Seems to be a big issue.

Why you ever want to write to a get property?

Cheers,
Hermann


