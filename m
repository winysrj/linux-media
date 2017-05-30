Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36246 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdE3TfF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 15:35:05 -0400
Received: by mail-wr0-f175.google.com with SMTP id j27so6307276wre.3
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 12:35:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170528234200.2ffdd351@macbox>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li> <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
 <20170528234200.2ffdd351@macbox>
From: Karl Wallin <karl.wallin.86@gmail.com>
Date: Tue, 30 May 2017 21:35:03 +0200
Message-ID: <CAML3znGxh2t9VQLMMsqQs0Okeos_enNTF=367QFKwmM=y__x+Q@mail.gmail.com>
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of function"
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, Thomas Kaiser <thomas@kaiser-linux.li>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Sorry for not replying earlier, work.
I came so far as to download the patches (via n00bishly pasting the
actual content of the .patch-files into .patch-files since my git
cherry-pick command didn't work) but then after trying to apply them I
got a prompt with specifying the path of the file and didn't research
that further.

I downloaded the latest release from GIT and now it actually builds!!! :D :=
D

However it does not install :(

"root@nuc-d54250wyk:/home/ubuntu/media_build# make install
make -C /home/ubuntu/media_build/v4l install
make[1]: Entering directory '/home/ubuntu/media_build/v4l'
make[1]: *** No rule to make target 'media-install', needed by 'install'.  =
Stop.
make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
Makefile:15: recipe for target 'install' failed
make: *** [install] Error 2"

I've gone into "v4l" and looked for a "media-install" file but haven't
found any.

Perhaps this is something I've misunderstood and easy to fix so I
finally can install it?

Best Regards - Karl
Med v=C3=A4nlig h=C3=A4lsning / Best Regards - Karl Wallin

karl.wallin.86@gmail.com

P.S. Om mitt mail b=C3=B6r vidarebefodras, v=C3=A4nligen g=C3=B6r detta ist=
=C3=A4llet f=C3=B6r
att =C3=A5terkomma med en email-adress i ett svar till mig. / If my mail
should be forwarded then please forward it instead of replying to me
with an email address. P.S.


2017-05-28 23:42 GMT+02:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> Am Sun, 28 May 2017 21:06:33 +0200
> schrieb Karl Wallin <karl.wallin.86@gmail.com>:
>
> All,
>
>> In "/home/ubuntu/media_build/v4l/cec-core.c" changed row 142 from:
>> "ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);" to:
>> "ret =3D device_add(&devnode->dev);"
>> and row 186 from:
>> "cdev_device_del(&devnode->cdev, &devnode->dev);" to:
>> "device_del(&devnode->dev);"
>
> Until the upstream media_build repository gets the neccessary backport
> patch treatment, you can apply [1] and [2] to media_build which should
> fix all build issues.
>
> Best regards,
> Daniel
>
> [1]
> https://github.com/herrnst/media_build/commit/4766a716c629707d58d625c6cdf=
d8c395fd6ed61
> [2]
> https://github.com/herrnst/media_build/commit/01507a9c32a301c8fc021dcaf1b=
943799ff3da51
