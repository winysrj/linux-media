Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:9103 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdFZKAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:00:17 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22864.56056.222371.477817@morden.metzler>
Date: Mon, 26 Jun 2017 11:59:20 +0200
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, "Jasmin J." <jasmin@anw.at>,
        "Takiguchi\, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "tbird20d\@gmail.com" <tbird20d@gmail.com>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
In-Reply-To: <20170626061920.2f0aa781@vento.lan>
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
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab writes:
 > Em Sun, 25 Jun 2017 19:52:59 +0200
 > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
 > 
 > > Am Sat, 24 Jun 2017 13:50:01 -0300
 > > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
 > > 
 > > > Em Thu, 22 Jun 2017 23:35:27 +0200
 > > > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
 > > > 
 > > > Would it be possible to change things at the dddvb tree to make
 > > > it to use our coding style (for example, replacing CamelCase by the
 > > > kernel_style), in order to minimize the amount of work to sync from
 > > > your tree?  
 > > 
 > > Note that this mostly (if not only) applies to the demodulator drivers. ddbridge itself is okay in this regard and has only some minors like indent, whitespace and such. There's one bigger thing though I'm not sure of if it needs to be changed: Beginning with the 0.9.9-tarball release, functionality was split from ddbridge-core.c into ddbridge.c, ddbridge-i2c.c, ddbridge-mod.c and ddbridge-ns.c (the two latter being modulator and netstream/octonet related code, which we don't need at this time). The issue is that this wasn't done by updating the build system to build multiple objects, but rather build from ddbridge.c which then does '#include "ddbridge-core.c"', and in that file '#include "ddbridge-i2c.c"'. See [1] for how it actually looks like in the file. Mauro, do you think this is acceptable?
 > 
 > Splitting it is OK. Including a *.c file no. It shouldn't be hard to

The main reason for using includes at the time were that the OctopusNet driver
(see https://github.com/DigitalDevices/dddvb/blob/master/ddbridge/octonet.c)
was using the same files but with different defines set.
Those differences are pretty much gone now.


> change the makefile to:
 > 	obj-ddbridge = ddbridge-main.o ddbridge-core.o ddbridge-i2c.o \
 > 		       ddbridge-modulator.o and ddbridge-ns.o
 > 
 > The only detail is that "ddbridge.c" should be renamed to 
 > ddbridge-core.c (or something similar) and some *.h files will
 > be needed.

Hmm, ddbridge -> ddbridge-main would be fine.
Renaming ddbridge to ddbridge-core and ddbridge-core to something else
would be confusing.


Regards,
Ralph
