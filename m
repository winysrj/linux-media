Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61425 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935033AbeCEMuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 07:50:39 -0500
Date: Mon, 5 Mar 2018 09:50:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PULL] DVB-mmap Kconfig typo fix
Message-ID: <20180305095033.052e464d@vento.lan>
In-Reply-To: <CAOcJUbzpbxtNGVrNepp_mhmC0XDtFv9324EqSTFyCGG0pv+J7Q@mail.gmail.com>
References: <CAOcJUbzpbxtNGVrNepp_mhmC0XDtFv9324EqSTFyCGG0pv+J7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 1 Mar 2018 07:55:20 -0500
Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:

> Mauro,
> 
> Please pull the following typo fix in the Kconfig for dvb-mmap:
> 
> The following changes since commit 4df7ac5f42087dc9bcbed04b5cada0f025fbf9ef:
> 
>   drivers/media/Kconfig: typo: replace `with` with `which` (2018-02-15
> 08:01:22 -0500)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/mkrufky/dvb.git dvb-mmap-v3
> 
> for you to fetch changes up to 4df7ac5f42087dc9bcbed04b5cada0f025fbf9ef:
> 
>   drivers/media/Kconfig: typo: replace `with` with `which` (2018-02-15
> 08:01:22 -0500)

There's something wrong with it:

 $ git pull git://linuxtv.org/mkrufky/dvb.git dvb-mmap-v3
>From git://linuxtv.org/mkrufky/dvb
 * branch                      dvb-mmap-v3 -> FETCH_HEAD
fatal: Not possible to fast-forward, aborting.

Anyway, I'll apply the patch from the one you sent via the ML.

Regards,
Mauro
