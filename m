Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.poss.co.nz ([210.54.213.75]:1749 "EHLO riffraff.iposs.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752282Ab2JBBf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 21:35:57 -0400
From: Michael West <michael@iposs.co.nz>
To: Martin Burnicki <martin.burnicki@burnicki.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 2 Oct 2012 14:30:25 +1300
Subject: RE: Current media_build doesn't succeed building on kernel 3.1.10
Message-ID: <DCBB30B3D32C824F800041EE82CABAAE03203D63BAD2@duckworth.iposs.co.nz>
References: <201209302052.42723.martin.burnicki@burnicki.net>
 <20121001110241.2f5ab052@redhat.com>
 <201210012131.13441.martin.burnicki@burnicki.net>
In-Reply-To: <201210012131.13441.martin.burnicki@burnicki.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Martin Burnicki <martin.burnicki@burnicki.net> wrote:
Hi,
> 
> Mauro Carvalho Chehab wrote:
> > Em Sun, 30 Sep 2012 20:52:42 +0200
> >
> > Martin Burnicki <martin.burnicki@burnicki.net> escreveu:
> > > Hi all,
> > >
> > > is anybody out there who can help me with the media_build system? 
> > > I'm trying to build the current modules on an openSUSE 12.1 system 
> > > (kernel 3.1.10, x86_64), but I'm getting compilation errors because 
> > > the s5k4ecgx driver uses function devm_regulator_bulk_get() which 
> > > AFAICS has been introduced in kernel 3.4 only. When I run the 
> > > ./build script compilation stops with these messages:
> > >
> > >  CC [M]  /root/projects/media_build/v4l/s5k4ecgx.o
> > > media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_load_firmware':
> > > media_build/v4l/s5k4ecgx.c:346:2: warning: format '%d' expects 
> > > argument of \ type 'int', but argument 4 has type 'size_t' 
> > > [-Wformat]
> > > media_build/v4l/s5k4ecgx.c: In function 's5k4ecgx_probe':
> > > media_build/v4l/s5k4ecgx.c:977:2: error: implicit declaration of \
> > >     function 'devm_regulator_bulk_get'
> > > [-Werror=implicit-function-declaration] cc1: some warnings being 
> > > treated as errors
> >
> > Those are warnings. It wil compile if you disable 
> > -Werror=implicit-function-declaration.
> 
> Hm, yes. Even though the module would finally not load due to "missing symbols" this won't matter since I don't need this module. So I suppose I need something like
> 
> EXTRA_CFLAGS=-Wno-error=implicit-function-declaration
> 
> to let this be treated like a warning and thus the build process will continue. However, I'm trying to use the ./build script from
> 
> git clone git://linuxtv.org/media_build.git
> 
> which seems to be best practice to get new modules added to an older kernel. 
> Can you or someone else tell me how to pass these EXTRA_CFLAGS to the ./build script?
> 
> I've tried several ways without success.
> 
> Martin
>

I've had the same problem here trying to get it to run on 3.2 kernel Ubuntu 12.04.  And new 3.4 and 3.5 kernels worked but I had other problems with stability so need this to build.

Watch out with that -Wno-error=implicit-function-declaration as it is not supported by gcc.  The gcc documentation says there is no 'no-error' version of this warning option.  So I'm not 100% sure how to turn these errors back into warnings.

Anyway I have found another quick solution to the problems that worked for me.

These are the steps I did:
Load up a terminal windows and start the build as normal.  (you may want to start with a fresh media build folders)
git clone git://linuxtv.org/media_build.git
cd media_build 
./build

Then as soon as it starts building .o files load a second terminal window and do the following:
cd media_build/v4l
nano s5k4ecgx.c

Now find the line with 'devm_regulator_bulk_get' function call and either comment or delete this line and the line below (it flows onto two lines)
Save this change and wait for the build to complete as normal

This is a very temp fix but it will at least let you build.  If you run build again it will overwrite the s5k4ecgx.c file with the incompatible one.

If it's not a simple change to suppress these errors then it might be better to either patch s5k4ecgx.c or somewhere else to detect the kernel version and not compile those lines or the whole module.  
Another option is to create a dummy function called 'devm_regulator_bulk_get' in a header somewhere.
And another simple solution is to create a diff patch to change those lines and stick that in the backports folder and set this to run on kernel 3.3 and older.

Hope this helps

Michael West



