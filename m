Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:39776 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab0BDJhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 04:37:23 -0500
Date: Thu, 4 Feb 2010 11:36:40 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Alan Carvalho de Assis <acassis@gmail.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	linux-arm-kernel@lists.infradead.org, mchehab@infradead.org
Subject: Re: [PATCH] RFC: mx27: Add soc_camera support
Message-ID: <20100204093640.GA7357@jasper.tkos.co.il>
References: <1260885686-8478-1-git-send-email-acassis@gmail.com>
 <37367b3a0912150607v713edc32y3578fa2a0c8c61db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37367b3a0912150607v713edc32y3578fa2a0c8c61db@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Tue, Dec 15, 2009 at 12:07:43PM -0200, Alan Carvalho de Assis wrote:
> Please note: I just get it compiling and loaded correctly on the
> mainline kernel.
> 
> If you have a board powered by i.MX27 and with a camera supported by
> soc_camera driver, I will be glad case you can do a try.

I'm now in the process of making this driver work on i.MX25. The CSI hardware 
of the i.MX25 is very similar to the i.MX27 one. If you have any updates for 
this driver please let me know.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
