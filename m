Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33686 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdFDGty (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Jun 2017 02:49:54 -0400
Received: by mail-pf0-f195.google.com with SMTP id f27so17183855pfe.0
        for <linux-media@vger.kernel.org>; Sat, 03 Jun 2017 23:49:53 -0700 (PDT)
Date: Sun, 4 Jun 2017 16:50:04 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Karl Wallin <karl.wallin.86@gmail.com>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, Thomas Kaiser <thomas@kaiser-linux.li>
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of
 function"
Message-ID: <20170604064956.GA22567@ubuntu.windy>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
 <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
 <20170528234200.2ffdd351@macbox>
 <CAML3znGxh2t9VQLMMsqQs0Okeos_enNTF=367QFKwmM=y__x+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAML3znGxh2t9VQLMMsqQs0Okeos_enNTF=367QFKwmM=y__x+Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 30, 2017 at 09:35:03PM +0200, Karl Wallin wrote:
> Hi!
> 
> Sorry for not replying earlier, work.
> I came so far as to download the patches (via n00bishly pasting the
> actual content of the .patch-files into .patch-files since my git
> cherry-pick command didn't work) but then after trying to apply them I
> got a prompt with specifying the path of the file and didn't research
> that further.
> 
> I downloaded the latest release from GIT and now it actually builds!!! :D :D
> 
> However it does not install :(
> 
> "root@nuc-d54250wyk:/home/ubuntu/media_build# make install
> make -C /home/ubuntu/media_build/v4l install
> make[1]: Entering directory '/home/ubuntu/media_build/v4l'
> make[1]: *** No rule to make target 'media-install', needed by 'install'.  Stop.
> make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
> Makefile:15: recipe for target 'install' failed
> make: *** [install] Error 2"
> 
> I've gone into "v4l" and looked for a "media-install" file but haven't
> found any.
> 
> Perhaps this is something I've misunderstood and easy to fix so I
> finally can install it?


This was also noticed by Olli Salonen (see thread "media_build: fails
to install"). I note there what the problem is but I don't know how
to fix it.

Vince
