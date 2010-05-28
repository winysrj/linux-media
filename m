Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab0E1WPu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 18:15:50 -0400
Date: Fri, 28 May 2010 19:15:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tm6000: rewrite copy_streams
Message-ID: <20100528191538.5dbb1db5@pedra>
In-Reply-To: <4C003CB9.1090700@arcor.de>
References: <1275069820-23980-1-git-send-email-stefan.ringel@arcor.de>
	<4C003CB9.1090700@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 May 2010 23:59:21 +0200
Stefan Ringel <stefan.ringel@arcor.de> escreveu:

> Am 28.05.2010 20:03, schrieb stefan.ringel@arcor.de:
> > From: Stefan Ringel <stefan.ringel@arcor.de>
> >
> > fusion function copy streams and copy_packets to new function copy_streams.
> >
> > Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> > ---
> >  drivers/staging/tm6000/tm6000-usb-isoc.h |    5 +-
> >  drivers/staging/tm6000/tm6000-video.c    |  329 +++++++++++-------------------
> >  2 files changed, 119 insertions(+), 215 deletions(-)
> >
> > diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
> > -- snipp
> >   
> Mauro can you superseded the patch from 28.05.2010 , 18:03 h

Stefan,

Please test your patches before sending. This is the second patch that you've sent
that doesn't even compile.

-- 

Cheers,
Mauro
