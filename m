Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51280 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0ENGAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 02:00:07 -0400
Date: Fri, 14 May 2010 08:00:49 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Frank Schaefer <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca-sonixj: ioctl VIDIOC_DQBUF blocks for 3s and retuns EIO
Message-ID: <20100514080049.1cf7c726@tele>
In-Reply-To: <4BEC21B9.4010605@googlemail.com>
References: <4BEC21B9.4010605@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 13 May 2010 17:58:49 +0200
Frank Schaefer <fschaefer.oss@googlemail.com> wrote:

> I'm not sure if I'm hitting a bug or this is the expected driver
> behavior: With a Microsoft LifeCam VX-3000 (045e:00f5) and
> gspca-sonixj, ioctl VIDIOC_DQBUF intermittently blocks for exactly 3
> seconds and then returns EIO.
> I noticed that it strongly depends on the captured scenery: when it's
> changing much, everything is fine.
> But when for example capturing the wall under constant (lower) light
> conditions, I'm getting this error nearly permanently.
> 
> It's a JPEG-device, so I guess the device stops sending data if the
> picture doesn't change and that's how it should be.
> But is the long blocking + EIO the way drivers should handle this
> situtation ?

Hello Frank,

You are right, this is a bug. I did not know that a webcam could suspend
streaming when the image did not change. I will remove the timeout.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
