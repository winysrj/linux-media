Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51449 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZIUKCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 06:02:31 -0400
Received: by bwz6 with SMTP id 6so1815309bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 03:02:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253508863.3255.10.camel@pc07.localdom.local>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
	 <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
	 <1253506233.3255.6.camel@pc07.localdom.local>
	 <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
	 <1253508863.3255.10.camel@pc07.localdom.local>
Date: Mon, 21 Sep 2009 12:02:34 +0200
Message-ID: <d9def9db0909210302m44f8ed77wfca6be3693491233@mail.gmail.com>
Subject: Re: Bug in S2 API...
From: Markus Rechberger <mrechberger@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----
in dvb-frontend.c:
 ----
         if(cmd == FE_GET_PROPERTY) {

                 tvps = (struct dtv_properties __user *)parg;
                 dprintk("%s() properties.num = %d\n", __func__, tvps->num);
                 dprintk("%s() properties.props = %p\n", __func__, tvps->props);
                 ...
                 if (copy_from_user(tvp, tvps->props, tvps->num *
 sizeof(struct dtv_property)))
 ----


> OK,
>
> thought I'll have never to care for it again.
>
> ENUM calls should never be W.
>
> Hit me for all I missed.
>
> Cheers,
> Hermann

you are not seeing the point of it it seems

Documentation/ioctl-number.txt

----
If you are adding new ioctl's to the kernel, you should use the _IO
macros defined in <linux/ioctl.h>:

    _IO    an ioctl with no parameters
    _IOW   an ioctl with write parameters (copy_from_user)
    _IOR   an ioctl with read parameters  (copy_to_user)
    _IOWR  an ioctl with both write and read parameters.
----
copy from user is required in order to copy the keys for the requested
elements into the kernel.
copy to user is finally used to play them back.

Markus
