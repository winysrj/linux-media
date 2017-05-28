Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout014.mail.hostpoint.ch ([217.26.49.174]:62767 "EHLO
        mxout014.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750995AbdE1UBP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 16:01:15 -0400
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of
 function"
To: Karl Wallin <karl.wallin.86@gmail.com>, linux-media@vger.kernel.org
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
 <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
 <48f09c13-817b-f496-0721-b2bf8533d3d3@kaiser-linux.li>
 <CAML3znGvFv7Gd0jHUVGn45+Phzn6dkUEhcHY16h-6BQg4r6joQ@mail.gmail.com>
From: Thomas Kaiser <thomas@kaiser-linux.li>
Message-ID: <b87109c6-9af7-a39c-8c45-eaac2dbb27d4@kaiser-linux.li>
Date: Sun, 28 May 2017 22:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAML3znGvFv7Gd0jHUVGn45+Phzn6dkUEhcHY16h-6BQg4r6joQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.05.2017 21:33, Karl Wallin wrote:
> Thanks for such a quick reply :)
> 
> Of course *facepalm* should have thought of that "./build" downloads
> everything again and of course replaces my modified "cec-core.c".
> I ran "make" and ran into new problems:
> 
> 
> Ok so using logic I should do the same changes in
> "/home/ubuntu/media_build/v4l/media-devnode.c":
> In ""/home/ubuntu/media_build/v4l/media-devnode.c" changed row 257 from:
> "ret = cdev_device_add(&devnode->cdev, &devnode->dev);" to:
> "ret = device_add(&devnode->dev);"
> and row 293 from:
> "cdev_device_del(&devnode->cdev, &devnode->dev);" to:
> "device_del(&devnode->dev);"
> and then run "make"
> 
> However it fails again :(
> 

>    CC [M]  /home/ubuntu/media_build/v4l/serial_ir.o
> /home/ubuntu/media_build/v4l/serial_ir.c:837:21: error: expected ')'
> before 'int'
>   module_param_hw(io, int, ioport, 0444);
>                       ^~~
> /home/ubuntu/media_build/v4l/serial_ir.c:841:25: error: expected ')'
> before 'ulong'
>   module_param_hw(iommap, ulong, other, 0444);
>                           ^~~~~
> /home/ubuntu/media_build/v4l/serial_ir.c:849:26: error: expected ')'
> before 'int'
>   module_param_hw(ioshift, int, other, 0444);
>                            ^~~
> /home/ubuntu/media_build/v4l/serial_ir.c:852:22: error: expected ')'
> before 'int'
>   module_param_hw(irq, int, irq, 0444);
>                        ^~~
> /home/ubuntu/media_build/v4l/serial_ir.c:855:28: error: expected ')'
> before 'bool'
>   module_param_hw(share_irq, bool, other, 0444);
>                              ^~~~
> scripts/Makefile.build:301: recipe for target
> '/home/ubuntu/media_build/v4l/serial_ir.o' failed
> make[3]: *** [/home/ubuntu/media_build/v4l/serial_ir.o] Error 1
> Makefile:1524: recipe for target '_module_/home/ubuntu/media_build/v4l' failed
> make[2]: *** [_module_/home/ubuntu/media_build/v4l] Error 2
> make[2]: Leaving directory '/usr/src/linux-headers-4.10.0-21-generic'
> Makefile:51: recipe for target 'default' failed
> make[1]: *** [default] Error 2
> make[1]: Leaving directory '/home/ubuntu/media_build/v4l'
> Makefile:26: recipe for target 'all' failed
> make: *** [all] Error 2
> 
> So I'm guessing that "/home/ubuntu/media_build/v4l/serial_ir.c" needs
> to be modified since it expects a ")" before the integer (numerical)
> value?
> 
> /Karl

Hi Karl

I compiled only the ddbridge driver. So I did not have to compile these files you have problems with. Therefor I don't know what is going on here, sorry.

Thomas
