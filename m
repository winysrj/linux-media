Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37996
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935486AbdGTPTq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:19:46 -0400
Date: Thu, 20 Jul 2017 12:19:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, "Jasmin J." <jasmin@anw.at>,
        "Takiguchi\, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "tbird20d\@gmail.com" <tbird20d@gmail.com>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170720121934.3da2f352@vento.lan>
In-Reply-To: <22865.61290.964849.36217@morden.metzler>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
        <20170621225712.426d3a17@audiostation.wuest.de>
        <22860.14367.464168.657791@morden.metzler>
        <20170624135001.5bcafb64@vento.lan>
        <20170625195259.1623ef71@audiostation.wuest.de>
        <20170626061920.2f0aa781@vento.lan>
        <22864.56056.222371.477817@morden.metzler>
        <20170626171701.58dac8d0@audiostation.wuest.de>
        <22865.61290.964849.36217@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Jun 2017 07:38:50 +0200
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Daniel Scheller writes:
>  > Am Mon, 26 Jun 2017 11:59:20 +0200
>  > schrieb Ralph Metzler <rjkm@metzlerbros.de>:
>  >   
>  > > Mauro Carvalho Chehab writes:  
>  > >  > 
>  > >  > Splitting it is OK. Including a *.c file no. It shouldn't be hard
>  > >  > to    
>  > > [...]  
>  > > > change the makefile to:
>  > >  > 	obj-ddbridge = ddbridge-main.o ddbridge-core.o
>  > >  > ddbridge-i2c.o \ ddbridge-modulator.o and ddbridge-ns.o
>  > >  > 
>  > >  > The only detail is that "ddbridge.c" should be renamed to 
>  > >  > ddbridge-core.c (or something similar) and some *.h files will
>  > >  > be needed.    
>  > > 
>  > > Hmm, ddbridge -> ddbridge-main would be fine.  
>  > 
>  > Funny, that's exactly the naming I had in mind when thinking about this
>  > in the past :)
>  > 
>  > So, I'll propose a rough todo (commit list) for me (I will do and
>  > care about this) then:
>  > 
>  > - 1/4: (Step 0) Since dddvb-0.9.9b besides the split also involved
>  >   reordering the functions in the code, this will be repeated with the
>  >   current mainline driver (helps keeping the diff with the actual code
>  >   bump cleaner)
>  > - 2/4: Do the split like done in 0.9.9 with the mainline driver, but do
>  >   it by having multiple objects in the makefile, adding header files
>  >   with prototypes where required
>  > - 3/4: Bump the driver code with what is already there (means, the
>  >   pre-cleaned variant w/o modulator and netstream/octonet stuff)
>  > - 4/4 (or 4/x): Apply any additional patches (like the "enable msi by
>  >   default Kconf opt, marked EXPERIMENTAL" thing I did to work around
>  >   the still problematic MSI IRQ stuff to let users have a better
>  >   experience)
>  > 
>  > When done, I'll post the patches for early review, but they'll have a
>  > hard dependency on the stv0910/stv6111 demod/tuner drivers (don't feel
>  > like ripping this out since we want that support anyway).
>  > 
>  > Additionally,I can do this for dddvb and submit it to the DigitalDevices dddvb
>  > repository (GitHub Pull Request) so we're at least in-sync wrt
>  > building the driver.
>  > 
>  > Ralph, Mauro, are you ok with this?  
> 
> I cannot promise which changes I will accept and when. Some will likely break
> other things like building the OctopusNet image.
> 
> The public DigitalDevices repository also is not the one I am using for development.
> So, changes will first go into our private repository and will only go upstream
> for releases.

Are there any way where we can help to make easier to synchronize
upstream with your internal tree?

As Daniel mentioned that he used some scripts, perhaps he can send
them for you to run on your tree.

Another alternative would be if you could release a "fork" of your
development tree before a release, as sort of "release candidate"
or something similar, at least while we're taking some efforts to
synchronize it with upstream.


Thanks,
Mauro
