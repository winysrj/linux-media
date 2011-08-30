Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60791 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1H3XfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 19:35:04 -0400
Received: by wyg24 with SMTP id 24so99528wyg.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 16:35:02 -0700 (PDT)
Subject: Re: Afatech AF9013
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: Jason Hecker <jwhecker@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <CAL9G6WWrkHgShXuyJRADgdmtQh41Rsz_-BGuQV4WDWfLrdHBTA@mail.gmail.com>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	 <CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
	 <1313949634.2874.13.camel@localhost>
	 <CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
	 <CAL9G6WUFddsFM2V46xXCDWEfhfCR0n5G-8S4JSYwLLkmZnYu7g@mail.gmail.com>
	 <CAATJ+fsUWPjh5aq38triZOu0-DmU=nCbd77qUzxUn5kiDiaR+w@mail.gmail.com>
	 <CAATJ+ftemL4NYTQLxLw4vmXpD+nFfxrUVjmapUt9EzYJNqH6FQ@mail.gmail.com>
	 <CAL9G6WWrkHgShXuyJRADgdmtQh41Rsz_-BGuQV4WDWfLrdHBTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 00:31:07 +0100
Message-ID: <1314747067.23170.37.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-08-29 at 20:40 +0200, Josu Lazkano wrote:
> 2011/8/23 Jason Hecker <jwhecker@gmail.com>:
> > Damn, this patch didn't help so maybe forget this patch.  Tuner A is
> > still messed up.
> >
> 
> Hello, thanks all to reply this post. I have no idea how to apply the
> patch on my Debian Squeeze. Can you help to apply the patch?
> 
> Thanks your all your help.
It is best applied using media_build and using a copy from the patchwork
server. You can just copy the raw email to a text file, but sometimes it
is malformed.

Since you originally used s2-liplianin you just need patchutils to apply
it to that. However, since it is older, I doubt it will apply cleanly.

https://patchwork.kernel.org/patch/1090012/

For media build, check if the required packages for Debian Squeeze are
the same as Ubuntu.

But, it appears the patch makes no difference.

Regards

Malcolm

MEDIA BUILD INSTALL (Instructions here are for Ubuntu)

Using Terminal install git, patchutils and perl with
sudo apt-get install git(or git-core)
sudo apt-get install patchutils
sudo apt-get install libdigest-sha1-perl
sudo apt-get install libproc-processtable-perl

Always build somewhere in your home directory with local user rights.
Only use super user rights to install. 

git clone git://linuxtv.org/media_build.git

cd media_build

---NO PATCH---

./build

sudo make install


---PATCH TO BE APPLIED---

Download any patch and place in the media_build directory and apply in
the following way.

./build (skip this if already built)

Wait for download and start to build. If you are confident that the
build will complete without errors break the build with <CTRL> C

Apply the patch. Make sure if applying multipliable patches they are
applied oldest first.

Just test the patch.
patch -d linux -p1 --dry-run < the_patch_name.patch

If okay apply it.
patch -d linux -p1 < the_patch_name.patch

make distclean

make

sudo make install

More in depth instructions here
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


