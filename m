Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57474 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZF3Kqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 06:46:34 -0400
Date: Tue, 30 Jun 2009 12:46:24 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: eric.paturage@orange.fr
Cc: linux-media@vger.kernel.org
Subject: Re: (very) wrong picture with sonixj driver and  0c45:6128
Message-ID: <20090630124624.7c64a597@free.fr>
In-Reply-To: <200906291843.n5TIhoO04486@neptune.localwarp.net>
References: <200906291843.n5TIhoO04486@neptune.localwarp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jun 2009 20:43:29 +0200 (CEST)
eric.paturage@orange.fr wrote:
> i am trying to use an "ngs skull" webcam with the gspca sonixj
> driver . i enclose a screen copy , so one can see what what i mean :
> the image is flatten vertically , there is 25% missing on the left .
> and the color is all wrong , over-bright  . (no matter how much i try
> to correct with v4l_ctl) the tests have been done with the latest
> mercurial version of the v4l drivers (from sunday evening) on
> 2.6.29.4 . I also tried it on 2 other computers (2.6.28.2 ) and
> 2.6.27.4 . with sames results .
	[snip]
> any idea what is going on ? 
> 
> I can provide more detailled log if needed , by setting the debug
> param in gspca_main 

Hello Eric,

Looking at the ms-win driver, it seems that the bridge is not the right
one. May you try to change it? This is done in the mercurial tree
editing the file:

	linux/drivers/media/video/gspca/sonixj.c

and replacing the line 2379 from:

{USB_DEVICE(0x0c45, 0x6128), BSI(SN9C110, OM6802, 0x21)}, /*sn9c325?*/

to

{USB_DEVICE(0x0c45, 0x6128), BSI(SN9C120, OM6802, 0x21)}, /*sn9c325*/
                                     ~~~

Don't forget to do 'make', 'make install' and 'rmmod gspca_sonixj'...

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
