Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750848AbZG2Hu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 03:50:58 -0400
Date: Wed, 29 Jul 2009 09:50:57 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Gregor =?iso-8859-1?Q?Glash=FCttner?= <gregorprivat@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Technical Details on Abus Digiprotect TV8802 Capture Card
Message-ID: <20090729075057.GA440@daniel.bse>
References: <6842a4030907240040k676997c9oe93b5b03548a6123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6842a4030907240040k676997c9oe93b5b03548a6123@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On Fri, Jul 24, 2009 at 09:40:35AM +0200, Gregor Glashüttner wrote:
> The card is called ABUS Digiprotect TV8802. Windows-software
> (including drivers and monitoring software) can be found at
> abus-sc.com (http://www.abus-sc.co.uk/International/Service-Downloads/Software?q=tv8802&Send=Search).

Coincidence that they removed the driver?..

>  Subsystem: 0x00000000

These cards can't be identified automatically.

>   Mute_GPDATA: 0x305000
>    Composite1_Mux   : 2
>    Composite1_GPDATA: 0x305002
>    Composite2_Mux   : 2
>    Composite2_GPDATA: 0x305001
>    Composite3_Mux   : 2
>    Composite3_GPDATA: 0x305003
>    Composite4_Mux   : 2
>    Composite4_GPDATA: 0x305002

This looks like it might work with card 108 (Phytec VD-009).

If not, can you put the card on a scanner and create pictures of both
sides so that we can trace the signals? Please upload them on
imageshack.us or similar instead of mailing them to the list.

  Daniel

