Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1EJJwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 05:52:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Tue, 10 May 2011 11:53:04 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com> <201105101132.11041.laurent.pinchart@ideasonboard.com> <BANLkTimLhOJstjpbxLSxS-qNPYhbfGxUNw@mail.gmail.com>
In-Reply-To: <BANLkTimLhOJstjpbxLSxS-qNPYhbfGxUNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101153.04978.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday 10 May 2011 11:49:10 javier Martin wrote:
> > Please try replacing the media-ctl -f line with
> > 
> > ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], \
> >        "OMAP3 ISP CCDC":0[SGRBG8 320x240], \
> >        "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> > 
> > --
> > Regards,
> > 
> > Laurent Pinchart
> 
> Hi Laurent,
> that didn't work either (Unable to start streaming: 32.)

With the latest 2.6.39-rc ? Lane-shifter support has been introduced very 
recently.

Can you post the output of media-ctl -p after configuring formats on your 
pipeline ?

-- 
Regards,

Laurent Pinchart
