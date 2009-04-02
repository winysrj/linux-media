Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49534 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZDBHO1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 03:14:27 -0400
Date: Thu, 2 Apr 2009 09:11:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Stian Skjelstad <stian@nixia.no>
Cc: linux-media@vger.kernel.org
Subject: Re: gpsca kernel BUG when disconnecting camera while streaming with
 mmap (2.6.29-rc8)
Message-ID: <20090402091112.5411b711@free.fr>
In-Reply-To: <1238347504.5232.17.camel@laptop>
References: <1238347504.5232.17.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009 19:25:03 +0200
Stian Skjelstad <stian@nixia.no> wrote:
	[snip]
> usb 2-2: USB disconnect, address 47
> gspca: urb status: -108
> gspca: urb status: -108
> gspca: disconnect complete
> BUG: unable to handle kernel NULL pointer dereference at 00000014
> IP: [<c02bc98e>] usb_set_interface+0x1e/0x1e0
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT 
	[snip]

Hello Stian,

You did not tell which version of gspca you use. If it is the one of a
kernel older than 2.6.30, you should update. Also, may this problem
be reproduced?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
