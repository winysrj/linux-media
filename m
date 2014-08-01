Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep27.mx.upcmail.net ([62.179.121.47]:63622 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaHAEzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 00:55:05 -0400
Message-ID: <1406868897.2548.15.camel@bjoern-W35xSTQ-370ST>
Subject: Re: ddbridge -- kernel 3.15.6
From: Bjoern <lkml@call-home.ch>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Date: Fri, 01 Aug 2014 06:54:57 +0200
In-Reply-To: <21465.62099.786583.416351@morden.metzler>
References: <53C920FB.1040501@grumpydevil.homelinux.org>
	 <53CAAF9D.6000507@kaiser-linux.li>
	 <1406697205.2591.13.camel@bjoern-W35xSTQ-370ST>
	 <21465.62099.786583.416351@morden.metzler>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Do, 2014-07-31 at 09:38 +0200, Ralph Metzler wrote:
> Bjoern writes:

> I don't know anything about any "old or new style".
> Digital Devices did not submit any changes to the kernel tree.

Why does that not happen? Wouldn't it be easier for your consumers? Plug
in your card and voila, it works "out of the box"? But fine, Oliver
indeed has done some attempts there it seems.
 
> Oliver Endriss did and afterwards some strange things happened.

That something changed in V4L I found here (after I bought the devices):
http://linuxtv.org/wiki/index.php/Digital_Devices_DuoFlex_C%26T

> E.g. the CI driver (cxd2099) is still in staging for no valid reason. The
> reasons given apply only to ddbridge. Why isn't ddbridge in staging?

What are the reasons?

And if that is the case - _who is responsible_ for this still being in
staging? Then we can ask that person what is going on - if there is no
reason then that is bad and wrong. And I hope there is not only one
single person who decides what leaves staging, some backup should be
around I hope?

> It is not like drivers are not available and supported, just
> not in the mainline kernel tree. 

Right... and I hope that can be changed. I really really like the DD
hardware I have, but always having to rebuild everything with a new
kernel is just not my idea of how hardware should run in 2014 on Linux
anymore.

> Regards,
> Ralph

Regards,
Bjoern

