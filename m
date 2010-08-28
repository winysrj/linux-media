Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:59823 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0H1Hpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 03:45:30 -0400
Date: Sat, 28 Aug 2010 09:46:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Thomas Holzeisen <thomas@holzeisen.de>
Subject: Re: HG has errors on kernel 2.6.32
Message-ID: <20100828094648.6d69325f@tele>
In-Reply-To: <4C76C662.3070003@hoogenraad.net>
References: <4C1D1228.1090702@holzeisen.de>
	<4C5BA16C.7060808@hoogenraad.net>
	<5a5511b4767b245485b150836b1526f0.squirrel@holzeisen.de>
	<4C760DBC.5000605@hoogenraad.net>
	<4C768B43.9080403@holzeisen.de>
	<4C76C662.3070003@hoogenraad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 26 Aug 2010 21:54:10 +0200
Jan Hoogenraad <jan-conceptronic@hoogenraad.net> wrote:

> and change
> static  void jpeg_set_qual(u8 *jpeg_hdr,
> into
> static __attribute__ (( unused )) void jpeg_set_qual(u8 *jpeg_hdr,
> 
> at line 152 of linux/drivers/media/video/gspca/jpeg.h

Hi,

This warning occured while compiling the gspca subdriver sq930x. It has
been fixed (as a critical gspca crash) in the last gspca changes which
are in git://linuxtv.org/media_tree.git, branch staging/v2.6.36.

BTW, Mauro, is it possible to put them in the kernel 2.6.36?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
