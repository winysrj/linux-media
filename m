Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:42328 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZIMHfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 03:35:44 -0400
Date: Sun, 13 Sep 2009 09:35:39 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "test.r test.r" <test.application.r@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ZC0301 webcam, successful trace from spca5xx driver
Message-ID: <20090913093539.7750e5a0@tele>
In-Reply-To: <c62e66e90909120136s6e0bc796jc9cb3e45d2b7e467@mail.gmail.com>
References: <c62e66e90909120136s6e0bc796jc9cb3e45d2b7e467@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 12 Sep 2009 15:36:20 +0700
"test.r test.r" <test.application.r@gmail.com> wrote:

> Using the old spca5xx with Debian kernel 2.6.18 the webcam is working.
> "Release 0.60.00 as spca5xx-v4l1-goodbye" available in Debian etch.
> The traces below may help someone wanting to port this webcam to the
> new driver architecture.

Hi Guillaume,

The spca5xx-v4l1-goodbye is for kernels < 2.6.11. Does the version
gspcav1-20071224.tar.gz work too?

I checked the source code of both gspca v1 and gspca v2 without finding
any difference. A trace of gspca v1 may help. May you send me the full
trace of the start of video streaming? (dmesg from 'spca5xx_open' till
the end - please, no more than one second of streaming)

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
