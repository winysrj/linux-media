Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33245 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbZIXA3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 20:29:20 -0400
Subject: Re: Bug in S2 API...
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d9def9db0909212254v38755332v6b564eb882f111a7@mail.gmail.com>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
	 <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
	 <1253506233.3255.6.camel@pc07.localdom.local>
	 <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
	 <1253508863.3255.10.camel@pc07.localdom.local>
	 <d9def9db0909210302m44f8ed77wfca6be3693491233@mail.gmail.com>
	 <1253584852.3279.11.camel@pc07.localdom.local>
	 <d9def9db0909212031q67e12ba7j9030063baf19a98@mail.gmail.com>
	 <1253596088.3279.67.camel@pc07.localdom.local>
	 <d9def9db0909212254v38755332v6b564eb882f111a7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 02:27:55 +0200
Message-Id: <1253752075.5765.2.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 22.09.2009, 07:54 +0200 schrieb Markus Rechberger:
> On Tue, Sep 22, 2009 at 7:08 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> > All fine.
> >
> > But you do cut off parts of my messages.
> >
> > I would like to ask you to exercise a breakage, not only for stuff six
> > years back, but on recent S2 API.
> >
> 
> at this time there are definitely no DVB applications available which
> check the flags of the encoded IOCTL values for the S2-API
> definitions, there are just very few applications available which use
> this API at all.
> 
> if (IOCTL_WRITE(cmd))
>   copy data into buffer for ioctl
> 
> -- from the driver side --
> if (IOCTL_WRITE(cmd))
>   copy data from the other side
> process_ioctl()
> 
> At least the API specification should be valid however the rest is
> implemented is another story. It works as it is but it's still wrong.
> Since the S2-API is rather new it might be better to fix it up. It
> would be a little bit weird too that coding style has a higher
> priority in Linux than correct code.
> 
> it breaks the macros in asm-generic/ioctl.h
> 
> #define IOC_INOUT       ((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT)
> #define IOC_IN          (_IOC_WRITE << _IOC_DIRSHIFT)
> #define IOC_OUT         (_IOC_READ << _IOC_DIRSHIFT)
> #define _IOC_DIR(nr)            (((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK)
> 
> Basically I don't mind too much since we already maintain our own
> version which also supports other unix systems and is not limited to
> linux only...
> 
> Markus

Markus, this was granted to honor their prior efforts.

Please, don't use it against us.

Cheers,
Hermann


