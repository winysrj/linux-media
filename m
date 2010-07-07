Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48468 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0GGFoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 01:44:13 -0400
Date: Wed, 7 Jul 2010 07:44:31 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100707074431.66629934@tele>
In-Reply-To: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Jul 2010 17:40:18 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> I'm testing the VX-1000 model web cam in test builds of Ubuntu 10.10
> x86_64 and have found that the gspca drivers allow the microphone to
> work with a sound recorder initially. However, when I test sound and
> video together with Cheese, the microphone no longer works and doesn't
> work again on the computer until the web cam is detached and
> reattached.
> 
> I was able to track the events in the system logs as follows:
	[snip]
> Jul 5 16:53:37 kyleabaker-desktop kernel: [105042.537960] gspca:
> bandwidth not wide enough - trying again
	[snip]
> I opened Cheese to test sound and video at the 16:53 point. This seems
> to be unique to x86_64 systems as I'm getting reports that 32-bit
> users are not having any problems with this, but I don't have a 32-bit
> install to test myself.
> 
> The selected input microphone remains the one in the web cam, but the
> drivers fail or break when it is started with video.

Hi Kyle,

The problem is known. I have no fix yet, but it seems that you use a
USB 1.1. or that you have some other device on the same bus. May you
try to connect your webcam to an other USB port?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
