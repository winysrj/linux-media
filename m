Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:54095 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2EQGGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 02:06:07 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id A4265940049
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 08:05:59 +0200 (CEST)
Date: Thu, 17 May 2012 08:07:34 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: How fix driver for this USB camera (MT9T031 sensor and Cypress
 FX2LP USB bridge)
Message-ID: <20120517080734.16446c78@tele>
In-Reply-To: <loom.20120517T001241-393@post.gmane.org>
References: <loom.20120517T001241-393@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 May 2012 22:14:48 +0000 (UTC)
Simon Gustafsson <simong@simong.se> wrote:

> 2) Where should I begin? My gut feeling is to go for media/video/gspca/ov519.c,
> since it has the code for talking to the USB bridge chip (BRIDGE_OVFX2), and

Hi Simon,

The FX2 is a processor, and, in ov519, used as a bridge, it has been
programmed by OmniVision for their sensors. It is quite sure that its
firmware is different in your webcam.

To know more, you should examine USB traces done with some other driver
(ms-windows - the scripts I use to translate these traces for gspca are
in my web site)...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
