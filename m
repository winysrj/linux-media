Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:54773 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZHBIeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2009 04:34:00 -0400
Date: Sun, 2 Aug 2009 10:33:50 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
Message-ID: <20090802103350.19657a07@tele>
In-Reply-To: <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr>
	<alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 1 Aug 2009 16:56:06 -0500 (CDT)
Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:

> Several cameras are supported here, which all share the same USB 
> Vendor:Product number when started up in streaming mode. All of these 
> cameras use bulk transport for streaming, and all of them produce
> frames in JPEG format.

Hi Theodore,

Your patch seems ok, but:

- there is no kfree(sd->jpeg_hdr). Should be in stop0().

- as there is only one vend:prod, one line is enough in gspca.txt.

May you fix this and resend?

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
