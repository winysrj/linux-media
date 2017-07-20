Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38066
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965158AbdGTPgt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:36:49 -0400
Date: Thu, 20 Jul 2017 12:36:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi,
        "Jasmin J.\" <jasmin@anw.at>"@s-opensource.com
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170720123641.0395b0ac@vento.lan>
In-Reply-To: <22885.5395.942193.897565@morden.metzler>
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
        <22864.55204.841821.456223@morden.metzler>
        <20170626073944.1102ceb5@vento.lan>
        <22885.5395.942193.897565@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Jul 2017 20:12:35 +0200
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Mauro Carvalho Chehab writes:
>  > Em Mon, 26 Jun 2017 11:45:08 +0200
>  > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
>  >   

> > The media controller is generic enough to control all pipelines at
>  > the hardware level. It can be used to select frontend inputs, to
>  > dynamically add/remove CAM modules, etc.
>  > 
>  > If I remember well, in the case of the hardware I was working on that
>  > time, each frontend had 3 inputs (and the hardware had 2 identical
>  > sets of tuner/demod),  plus 3 MPEG-TS demuxes) and 2 CAM modules.
>  > 
>  > With the media controller, any arrangement between input, tuner,
>  > demod, demux and CAM is possible, as long as supported by
>  > the hardware.  
> 
> OK, for such complex arrangements it makes sense.
> I just thought it to be overkill for just the input selection

The media controller support is handled by the DVB core for the
general case. The needed bits that would give the flexibility that
ddbridge require shouldn't be hard to add.

> and it also has to run on older kernels where th MC stuff is
> not yet in the DVB core.

The MC DVB support is there since jan/2015 (Kernel 3.20):

commit a0246e02f466482a34c8ad94bedbe4efa498662d
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Fri Jan 2 12:19:51 2015 -0300

    [media] dvbdev: add support for media controller
    
    Provide a way to register media controller device nodes
    at the DVB core.
    
    Please notice that the dvbdev callers also require changes
    for the devices to be registered via the media controller.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

$ git describe a0246e02f4664
media/v3.20-1-9-ga0246e02f466


For older Kernels, there are a few ways to proceed:

1) use an approach like media_build for the DD tree, where the
   DVB core is replaced by a newer one. I guess it has support
   since v2.6.30, at least for the core.

2) Keep use the solution you have already, using ifdefs on your
   tree to keep it supported with legacy Kernels.

3) you could base DD trees at the backport tree:
	https://backports.wiki.kernel.org/index.php/Main_Page
   I never used it myself, but it should be covering the
   media drivers there too.


Thanks,
Mauro
