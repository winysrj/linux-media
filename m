Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:58945 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DANla (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 09:41:30 -0400
Date: Sun, 1 Apr 2012 15:41:27 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Ninja <Ninja15@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
Message-ID: <20120401134127.GB7571@uio.no>
References: <4F6B958C.4070406@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6B958C.4070406@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 22, 2012 at 10:11:40PM +0100, Ninja wrote:
> I started some testing and so far the changes seem to be fine, but I
> still get freezes from time to time. I have to admit that I still
> need to test if I get the same error with other applications than
> mythtv.

It seems to be CAM dependent for me, unfortunately. With a pretty standard
Conax CAM I am stable for a week or more, but with PowerCAM 4.6 I get errors
and timeouts in matters of hours.

It may of course be related to the fact that due to odd technicalities I
can't test the same transponders on the two CAMs. :-/

> Anyway I would like to see the changes in mainline. Maybe it would
> be a good idea to add a driver module parameter so the cam stuff
> (wait hack, ts passthrough) is only activated with the parameter
> set.

I've looked at splitting them in patches, but the CA passthrough enable has
unknown origin as far as I know. Maybe it's trivial enough that I can just
recreate it; does anyone know if that's commonly considered acceptable?
(The patch is only a few lines.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
