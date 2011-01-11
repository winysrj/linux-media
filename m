Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:44760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab1AKOq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 09:46:26 -0500
Message-ID: <4D2C895B.5090606@infradead.org>
Date: Tue, 11 Jan 2011 14:46:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: linux-media@vger.kernel.org,
	Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PULL] radio-si470x
References: <201101091544.06031.tobias.lorenz@gmx.net>
In-Reply-To: <201101091544.06031.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Tobias,

Em 09-01-2011 12:44, Tobias Lorenz escreveu:
> Hi Mauro,
> 
> Please pull from http://linuxtv.org/hg/~tlorenz/v4l-dvb
> 
> for the following 5 changesets:
> 
> 01/05: The de-emphasis should be setted if requested by module parameter
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/b29f01f1b11d
> 
> 02/05: The si470x i2c and usb driver support the RDS, so this ifdef statement
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/74bf5826ae4e
> 
> 03/05: We should go to err_video instead of err_all if this error is occured
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/7ea10526e134
> 
> 04/05: V4L/DVB: radio-si470x: remove the BKL lock used internally at the driver
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/9ddfe7347b9a
> 
> 05/05: V4L/DVB: radio-si470x: use unlocked ioctl
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/87712135ac8d

Most of the above patches are already on my tree. The only two that applied were
patches 01 and 02 (and the second with a conflict, and an error on it, that I fixed).
The other patches seemed to be already applied.

The mercurial tree is outdated and nobody is maintaining it anymore.
I don't care if you still want to use it to send me patches via mercurial, as I
have a script to handle things for it, but, in this case, you will need to manually
backport the upstream changes before sending me a pull request.

The better would be if you could migrate your development tree to git.

Thanks!
Mauro
