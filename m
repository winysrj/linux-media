Return-path: <linux-media-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:53523 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbZKKTHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 14:07:03 -0500
Date: Wed, 11 Nov 2009 19:06:59 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] videobuf-dma-contig.c: add missing #include
Message-ID: <20091111190659.GF2197@deprecation.cyrius.com>
References: <20091031102850.GA3850@deprecation.cyrius.com>
 <20091111155329.GA3731@deprecation.cyrius.com>
 <Pine.LNX.4.64.0911111936470.4072@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911111936470.4072@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2009-11-11 19:38]:
> > Are there any comments regarding the build fix I submitted?  This
> > issue is still there, as you can see at
> > http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> 
> Oh, I'm afraid, I've unwillingly stolen your patch:
> 
> http://linuxtv.org/hg/~gliakhovetski/v4l-dvb?cmd=changeset;node=d5defdb8768d
> 
> Sorry about that. But if your patch landed in patchwork, which it should, 
> thenmaybe yours will be used in the end.

Yes, it's here: http://patchwork.kernel.org/patch/56763/

Maybe you can add your acked-by.
-- 
Martin Michlmayr
http://www.cyrius.com/
