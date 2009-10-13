Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:35763 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761140AbZJMTiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 15:38:21 -0400
Received: by fxm27 with SMTP id 27so10618629fxm.17
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 12:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091013213119.7e790e7b@ieee.org>
References: <loom.20091011T180513-771@post.gmane.org>
	 <829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
	 <loom.20091012T223603-551@post.gmane.org>
	 <829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
	 <20091013012255.260afea3@ieee.org>
	 <829197380910121723i59d2498en10d166f523889fbd@mail.gmail.com>
	 <20091013213119.7e790e7b@ieee.org>
Date: Tue, 13 Oct 2009 15:37:43 -0400
Message-ID: <829197380910131237n5a09861bs204df901522cecc5@mail.gmail.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 13, 2009 at 3:31 PM, Giuseppe Borzi <gborzi@gmail.com> wrote:
> Thanks Devin,
> now DVB works as expected, i.e. I can change channel and w_scan
> finds the channels available in my area. The stick is recognized as
> card=1 instead of 53 as I expected, but still it works fine.
> Still no sound for analog TV, but that's a minor problem.
>
> Thanks again.

Can you please provide the output of dmesg after connecting the card?
I am not sure why it would recognize as card=1.  Do you have a
modprobe option setup forcing it to card=1?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
