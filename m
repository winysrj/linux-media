Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:35754 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbZHaJ2e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 05:28:34 -0400
Date: Mon, 31 Aug 2009 11:28:27 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Michel Xhaard <mxhaard@users.sourceforge.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus: problem with brightness control
Message-ID: <20090831112827.567a0a1f@tele>
In-Reply-To: <4A9A1AB6.2050801@freemail.hu>
References: <4A9A1AB6.2050801@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 30 Aug 2009 08:22:46 +0200
Németh Márton <nm127@freemail.hu> wrote:

> I am using a "Trust 610 LCD Powerc@m Zoom" device in webcam mode
> (USB ID=06d6:0031). I am running Linux 2.6.31-rc7 updated with the
> http://linuxtv.org/hg/v4l-dvb repository at version
> 12564:6f58a5d8c7c6.
> 
> When I start watching to the webcam picture and change the brightness
> value then I get the following result. The possible brigthness values
> are between 0 and 255.
	[snip]

Hi Márton,

I fixed this problem in my test repository. As I did some other changes
in sunplus.c, may you check if everything works for you?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
