Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48956 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752377AbeADS3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 13:29:16 -0500
Date: Thu, 4 Jan 2018 16:29:09 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: don't use whitespaces for indentation
Message-ID: <20180104162909.66c0c455@recife.lan>
In-Reply-To: <20180104130852.nfmae3fjxzrnja2q@valkosipuli.retiisi.org.uk>
References: <4e866518d3a00d4dedad069151cd447f66bd9387.1515068806.git.mchehab@s-opensource.com>
        <20180104130852.nfmae3fjxzrnja2q@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 4 Jan 2018 15:08:52 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Thu, Jan 04, 2018 at 07:27:48AM -0500, Mauro Carvalho Chehab wrote:
> > On several places, whitespaces are being used for indentation,
> > or even at the end of the line.
> > 
> > Fix them, by running a script that fix it inside drivers/media
> > and include/media.  
> 
> What kind of a script?

Just sent a patch series with the script, and addressing a bunch of
other places where we have bad spacing.

> Could you also add includ/uapi/media to this?

I added more places to it:

$ rmspaces.pl  $(find drivers/media -type f) $(find include/media -type f) include/uapi/linux/videodev2.h include/uapi/linux/v4l2-* include/uapi/linux/dvb/*

It is probably worth to run is also against staging/media. I'll do it in
separate.


Thanks,
Mauro
