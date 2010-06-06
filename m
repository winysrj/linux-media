Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab0FFPVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 11:21:16 -0400
Message-ID: <4C0BBCD3.8000101@redhat.com>
Date: Sun, 06 Jun 2010 12:20:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 autio isoc blocks
References: <4C09686E.5090601@arcor.de>
In-Reply-To: <4C09686E.5090601@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-06-2010 17:56, Stefan Ringel escreveu:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Hi Mauro,
> 
> I have check the windows usb log and if I have audio block it's say 0
> byte, but the data is complete 180 bytes until next block header. So I
> think it's good if that audio block (cmd=2) resize from 0 to 180

AFAIK, even if the data is empty, all blocks have 180 bytes of size.
Yet, maybe the block size simply doesn't apply for audio... Tests are
needed to double check what's the case here.

Cheers,
Mauro
