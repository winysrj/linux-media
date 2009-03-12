Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48652 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZCLOTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 10:19:48 -0400
Date: Thu, 12 Mar 2009 15:19:45 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] V2: soc-camera: setting the buswidth of camera
	sensors
Message-ID: <20090312141945.GO425@pengutronix.de>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903121429530.4896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903121429530.4896@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 02:31:17PM +0100, Guennadi Liakhovetski wrote:
> On Thu, 12 Mar 2009, Sascha Hauer wrote:
> 
> > Take 2: I hope I addressed all comments I receive in the first round.
> > 
> > The following patches change the handling of the bus width
> > for camera sensors so that a board can overwrite a sensors
> > native bus width
> > 
> > Sascha Hauer (5):
> >   soc-camera: add board hook to specify the buswidth for camera sensors
> >   pcm990 baseboard: add camera bus width switch setting
> >   mt9m001: allow setting of bus width from board code
> >   mt9v022: allow setting of bus width from board code
> >   soc-camera: remove now unused gpio member of struct soc_camera_link
> 
> Ok, the rest look good to me. So, after you fix or explain 2/5 I'll be 
> pulling them.

If by pulling you mean 'git pull' you can do it here:

git://git.pengutronix.de/git/sha/linux-2.6.git soc-camera-bus-switch

Thanks
  Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
