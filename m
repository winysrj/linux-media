Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout017.mail.hostpoint.ch ([217.26.49.177]:14329 "EHLO
        mxout017.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750802AbdE1TiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 15:38:24 -0400
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of
 function"
To: Karl Wallin <karl.wallin.86@gmail.com>, linux-media@vger.kernel.org
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
 <9102e964-8143-edd7-3a82-014ae0d29d48@kaiser-linux.li>
 <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
From: Thomas Kaiser <thomas@kaiser-linux.li>
Message-ID: <48f09c13-817b-f496-0721-b2bf8533d3d3@kaiser-linux.li>
Date: Sun, 28 May 2017 21:14:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAML3znHkCFrtQqXvZkCwiMGNkRdSAnHBDTvfeoaQdtq8kRMkQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.05.2017 21:06, Karl Wallin wrote:
> Hi Thomas,
> 
> Thanks for the help (and to Vincent as well) :)
> 
> In "/home/ubuntu/media_build/v4l/cec-core.c" changed row 142 from:
> "ret = cdev_device_add(&devnode->cdev, &devnode->dev);" to:
> "ret = device_add(&devnode->dev);"
> and row 186 from:
> "cdev_device_del(&devnode->cdev, &devnode->dev);" to:
> "device_del(&devnode->dev);"
> 
> Even if I do that when I try to build it again (using ./build) it
> seems to reload / revert the cec-core.c to the original file since I
> still get these errors even though I saved the changes in Notepadqq:
> "/home/ubuntu/media_build/v4l/cec-core.c:142:8: error: implicit
> declaration of function 'cdev_device_add'
> [-Werror=implicit-function-declaration]
>    ret = cdev_device_add(&devnode->cdev, &devnode->dev);"
> and
> "/home/ubuntu/media_build/v4l/cec-core.c:186:2: error: implicit
> declaration of function 'cdev_device_del'
> [-Werror=implicit-function-declaration]
>    cdev_device_del(&devnode->cdev, &devnode->dev);"
> 
> I am probably missing something here since it worked for you, would be
> grateful for your help :)
> 
> /Karl
> Med vänlig hälsning / Best Regards - Karl Wallin
> 

Hi Karl

The build downloads the latest source and overwrites your change (I think?)

I used "make" to compile.

After your have run the build script. Do the changes as you have described above. Run "make" to compile and "sudo make install" to install. This should do the trick.

Thomas
