Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39627 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754083AbdAHRi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Jan 2017 12:38:29 -0500
Date: Sun, 8 Jan 2017 17:38:31 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] solo6x10: use designated initializers
Message-ID: <20170108173831.GB30556@dell-m4800>
References: <20161217010536.GA140725@beast>
 <20161219195637.GA15652@dell-m4800>
 <CAGXu5jKFA6MtEWOFm+HDb1yy1pp9uFoRDS02G4qqn-7wWK7P7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKFA6MtEWOFm+HDb1yy1pp9uFoRDS02G4qqn-7wWK7P7A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 01:21:10PM -0800, Kees Cook wrote:
> > Since `ops` is static, what about this?
> > For the variant given below, you have my signoff.
> >
> >> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> >> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> >> @@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
> >>
> >>  int solo_g723_init(struct solo_dev *solo_dev)
> >>  {
> >> -     static struct snd_device_ops ops = { NULL };
> >> +     static struct snd_device_ops ops;
> 
> Ah! Yes, thanks. That works fine too. :) Can this be const as well?

No, it can't be const, it's used as parameter for snd_device_new() which
takes "struct snd_device_ops *".
