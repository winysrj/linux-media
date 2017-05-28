Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34417 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdE1TGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 15:06:35 -0400
Received: by mail-wm0-f49.google.com with SMTP id 123so14383892wmg.1
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 12:06:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
From: Karl Wallin <karl.wallin.86@gmail.com>
Date: Sun, 28 May 2017 21:06:33 +0200
Message-ID: <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of function"
To: Thomas Kaiser <thomas@kaiser-linux.li>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Thanks for the help (and to Vincent as well) :)

In "/home/ubuntu/media_build/v4l/cec-core.c" changed row 142 from:
"ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);" to:
"ret =3D device_add(&devnode->dev);"
and row 186 from:
"cdev_device_del(&devnode->cdev, &devnode->dev);" to:
"device_del(&devnode->dev);"

Even if I do that when I try to build it again (using ./build) it
seems to reload / revert the cec-core.c to the original file since I
still get these errors even though I saved the changes in Notepadqq:
"/home/ubuntu/media_build/v4l/cec-core.c:142:8: error: implicit
declaration of function 'cdev_device_add'
[-Werror=3Dimplicit-function-declaration]
  ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);"
and
"/home/ubuntu/media_build/v4l/cec-core.c:186:2: error: implicit
declaration of function 'cdev_device_del'
[-Werror=3Dimplicit-function-declaration]
  cdev_device_del(&devnode->cdev, &devnode->dev);"

I am probably missing something here since it worked for you, would be
grateful for your help :)

/Karl
Med v=C3=A4nlig h=C3=A4lsning / Best Regards - Karl Wallin

karl.wallin.86@gmail.com

P.S. Om mitt mail b=C3=B6r vidarebefodras, v=C3=A4nligen g=C3=B6r detta ist=
=C3=A4llet f=C3=B6r
att =C3=A5terkomma med en email-adress i ett svar till mig. / If my mail
should be forwarded then please forward it instead of replying to me
with an email address. P.S.


2017-05-28 14:28 GMT+02:00 Thomas Kaiser <thomas@kaiser-linux.li>:
> On 27.05.2017 21:28, Karl Wallin wrote:
>>
>> Hi!
>>
>> Sorry if this is something I should have figured out, I am bit
>> experienced with Linux but not at all a pro.
>>
>> Trying to build v4l-dvb on Ubuntu 17.04 (kernel 4.10.0-21-generic) and
>> get build errors.
>>
>> Dependencies are met:
>>
>> make[2]: Entering directory '/usr/src/linux-headers-4.10.0-21-generic'
>>    CC [M]  /home/ubuntu/media_build/v4l/cec-core.o
>> /home/ubuntu/media_build/v4l/cec-core.c: In function
>> 'cec_devnode_register':
>> /home/ubuntu/media_build/v4l/cec-core.c:142:8: error: implicit
>> declaration of function 'cdev_device_add'
>> [-Werror=3Dimplicit-function-declaration]
>>    ret =3D cdev_device_add(&devnode->cdev, &devnode->dev);
>>          ^~~~~~~~~~~~~~~
>> /home/ubuntu/media_build/v4l/cec-core.c: In function
>> 'cec_devnode_unregister':
>> /home/ubuntu/media_build/v4l/cec-core.c:186:2: error: implicit
>> declaration of function 'cdev_device_del'
>> [-Werror=3Dimplicit-function-declaration]
>>    cdev_device_del(&devnode->cdev, &devnode->dev);
>>    ^~~~~~~~~~~~~~~
>
>
> Hi Karl
>
> I changed in cec-core.c cdev_device_add(&devnode->cdev, &devnode->dev) an=
d
> cdev_device_del(&devnode->cdev, &devnode->dev) to device_add(&devnode->de=
v)
> and device_del(&devnode->dev).
>
> I can compile now and the driver runs with kernel 4.10.0-21-generic on
> Ubuntu 17.04.
>
> Thomas
>
