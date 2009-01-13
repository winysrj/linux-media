Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:37088 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZAMTm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 14:42:27 -0500
Date: Tue, 13 Jan 2009 20:33:20 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Roland Graf <roland.graf@alice.it>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with driver for  0ac8:301b Z-Star Microelectronics
 Corp. ZC0301 WebCam
Message-ID: <20090113203320.0b35816a@free.fr>
In-Reply-To: <200901132058.22336.roland.graf@alice.it>
References: <200901132058.22336.roland.graf@alice.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Jan 2009 20:58:22 +0100
Roland Graf <roland.graf@alice.it> wrote:

> Dear Gentlemen,

Hello Roland,

> I'm using the v4l-dvb driver with Kernel Version 22.6.26. 
> 
> Connecting the camera 0ac8:301b Z-Star Microelectronics Corp. ZC0301
> WebCam the driver for the camera is loaded correctly, but the
> sensorchip is not recognized.
	[snip]
> Installing v4l-dvb and gspcav1 doesn't work because these packages
> don't work together.
> 
> Is there some workaround for this Problem?

gspca v1 is not maintained anymore, and gspca v2 is included in
v4l-dvb.

Normally, in v4l-dvb, the zc0301 driver should not handle your webcam.
Did you think to remove its module from /lib/modules/...? Also, don't
forget to generate (and install) gspca and the zc3xx subdriver.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
