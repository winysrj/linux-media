Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:35966 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbZIUFHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 01:07:47 -0400
Subject: Re: Bug in S2 API...
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
	 <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
	 <1253506233.3255.6.camel@pc07.localdom.local>
	 <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 06:54:23 +0200
Message-Id: <1253508863.3255.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 21.09.2009, 06:42 +0200 schrieb Markus Rechberger:
> On Mon, Sep 21, 2009 at 6:10 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> > Am Montag, den 21.09.2009, 06:09 +0200 schrieb Markus Rechberger:
> >> On Mon, Sep 21, 2009 at 5:46 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> >> >
> >> > Am Montag, den 21.09.2009, 05:40 +0200 schrieb Markus Rechberger:
> >> >> while porting the S2api to userspace I came accross the S2-API definition itself
> >> >>
> >> >> #define FE_SET_PROPERTY            _IOW('o', 82, struct dtv_properties)
> >> >> #define FE_GET_PROPERTY            _IOR('o', 83, struct dtv_properties)
> >> >>
> >> >> while looking at this, FE_GET_PROPERTY should very likely be _IOWR
> >> >>
> >> >> in dvb-frontend.c:
> >> >> ----
> >> >>         if(cmd == FE_GET_PROPERTY) {
> >> >>
> >> >>                 tvps = (struct dtv_properties __user *)parg;
> >> >>
> >> >>                 dprintk("%s() properties.num = %d\n", __func__, tvps->num);
> >> >>                 dprintk("%s() properties.props = %p\n", __func__, tvps->props);
> >> >>                 ...
> >> >>                 if (copy_from_user(tvp, tvps->props, tvps->num *
> >> >> sizeof(struct dtv_property)))
> >> >> ----
> >> >>
> >> >> Regards,
> >> >> Markus
> >> >
> >> > Seems to be a big issue.
> >> >
> >> > Why you ever want to write to a get property?
> >> >
> >>
> >> to read out the API version for example.
> >> tvps->num is also used in order to check the boundaries of the property array.
> >>
> >> Markus
> >
> > Their are no writes allowed to manipulate get properties.
> >
> 
> the writes are needed in order to submit tvps->num, although _IOR will
> work _IOWR is the correct one in that case, aside of that you can just
> compare it with other calls (eg. v4l2), the ENUM calls are all _IOWR.
> They submit the index and retrieve the rest.
> 
> Markus

OK,

thought I'll have never to care for it again.

ENUM calls should never be W.

Hit me for all I missed.

Cheers,
Hermann


