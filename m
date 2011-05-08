Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:45409 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1EHQAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 12:00:07 -0400
Date: Sun, 8 May 2011 18:00:11 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "Roman B." <rbyshko@gmail.com>, linux-media@vger.kernel.org
Subject: Re: gspca_zc3xx (HV7131R sensor) driver brocken
Message-ID: <20110508180011.2a0d410d@tele>
In-Reply-To: <BANLkTinFCvSB5QOOq7bmuBDa65dnC0PNLA@mail.gmail.com>
References: <BANLkTinFCvSB5QOOq7bmuBDa65dnC0PNLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 8 May 2011 13:37:52 +0200
"Roman B." <rbyshko@gmail.com> wrote:

> since the upgrade of the kernel to 2.6.37.1 my webcamera (046d:08d7
> Logitech, Inc. QuickCam Communicate STX) is brocken. The problem is
> exactly the same as in this bug report:
> https://bugzilla.kernel.org/show_bug.cgi?id=24242 The problem of
> contrast seems to dissapear in the new 2.6.39-rc4 kernel, but that
> time the camera response is brocken. I'm not sure how to technically
> describe it correctly. I think the fps is very slow, causing a slight
> movement of the object create ugly picture where everything is
> blurred. I would be very glad to get my camera back working, as it was
> before. (I'm just wondering why should one change something at all...
> )
> I suppose the maintainer of the gspca driver is Jean-Francois Moine.
> However he seems not to react to the bugs in bugzilla. The simple
> search
	[snip]

Hi Roman,

Right, I am so busy that I never look at bugzilla!

Why do bugs appear in zc3xx? This subdriver handles more than one
hundred webcams. Most of the treatment was inherited from the gspca v1
by Michel Xhaard who gave me the sources and let me alone without any
information. In zc3xx, many webcams are driven by sequences copied from
ms-windows USB traces and it is not easy to add them standard controls
such as light frequency filtering. My fault, sometimes, I am too sure of
a change and it goes into a kernel without test. I am a bit more
careful now, and I have about 10 fixes which are waiting for testers..

Otherwise, it seems that the contast problem #24242 was fixed (see
commit 3d244065cb8764e).

But I did not know about this fps problem. May you get the last gspca
test version from my web site and do a usbmon trace? (I need the webcam
connection up to no more than 1 second of streaming)

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
