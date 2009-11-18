Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58542 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZKRKj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 05:39:26 -0500
From: Juergen Beisert <jbe@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Wed, 18 Nov 2009 11:39:18 +0100
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Robert Jarzmik <robert.jarzmik@free.fr>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it> <1258495463-26029-3-git-send-email-ospite@studenti.unina.it> <Pine.LNX.4.64.0911181110180.5702@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911181110180.5702@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911181139.19336.jbe@pengutronix.de>
Subject: Re: [PATCH 2/3] pcm990-baseboard: don't use pxa_camera init() callback
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mittwoch, 18. November 2009, Guennadi Liakhovetski wrote:
> On Tue, 17 Nov 2009, Antonio Ospite wrote:
> > pxa_camera init() is going to be removed.
> > Configure PXA CIF pins directly in machine init function.
>
> Same comment as to patch 1/3.
>
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>
> Even though the change seems obvious, it better be tested - in case
> someone reconfigures camera pins somewhere after
> pcm990_baseboard_init()... Juergen, would you be able to test it?

Lets see, if I can grab some hardware.

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
