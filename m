Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35793 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZJWN7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 09:59:32 -0400
Message-ID: <4AE1B928.9020001@gmail.com>
Date: Fri, 23 Oct 2009 16:09:44 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] v4l: Cleanup redundant tests on unsigned
References: <4AE18C9E.9090409@gmail.com>
In-Reply-To: <4AE18C9E.9090409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 23-10-09 12:59, Roel Kluin schreef:
> The variables are unsigned so the test `>= 0' is always true,
> the `< 0' test always fails. In these cases the other part of
> the test catches wrapped values.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---

I forgot the stats:

 drivers/media/common/tuners/tda9887.c           |    2 +-
 drivers/media/dvb/siano/smscoreapi.c            |    2 +-
 drivers/media/video/bt819.c                     |    2 +-
 drivers/media/video/hexium_gemini.c             |    2 +-
 drivers/media/video/hexium_orion.c              |    2 +-
 drivers/media/video/mxb.c                       |    2 +-
 drivers/media/video/s2255drv.c                  |    2 +-
 drivers/media/video/saa7110.c                   |    2 +-
 drivers/media/video/saa717x.c                   |    2 +-
 drivers/media/video/tuner-core.c                |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    2 +-
 drivers/media/video/vpx3220.c                   |    2 +-
 drivers/media/video/zoran/zoran_driver.c        |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

