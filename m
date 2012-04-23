Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44441 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2DWQRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:39 -0400
Date: Mon, 23 Apr 2012 09:17:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Johann Deneux <johann.deneux@gmail.comx>,
	Anssi Hannula <anssi.hannula@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-ID: <20120423161734.GB29290@core.coreip.homeip.net>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2012 at 03:21:04PM +0200, Antonio Ospite wrote:
> Hi,
> 
> here are a couple more of controls for the gspca ov534 subdriver.
> 
> In order to control the HUE value the sensor expects sin(HUE) and
> cos(HUE) to be set so I decided to reuse the fixed point implementation
> of sine and cosine from drivers/input/fixp-arith.h, see patches 2 and 3.
> 
> Dmitry, can the movement of fixp-arith.h in patch 2 go via the media
> tree?  That should ease up the integration of patch 3 in this series
> I think.

Yep, this is fine with me.

> 
> Jonathan, maybe fixp_sin() and fixp_cos() can be used in
> drivers/media/video/ov7670.c too where currently ov7670_sine() and
> ov7670_cosine() are defined, but I didn't want to send a patch I could
> not test.
> 
> BTW What is the usual way to communicate these cross-subsystem stuff?
> I CC-ed everybody only on the cover letter and on patches 2 and 3 which
> are the ones concerning somehow both "input" and "media".
> 
> Thanks,
>    Antonio
> 
> 
> Antonio Ospite (3):
>   [media] gspca - ov534: Add Saturation control
>   Input: move drivers/input/fixp-arith.h to include/linux
>   [media] gspca - ov534: Add Hue control
> 
>  drivers/input/ff-memless.c        |    3 +-
>  drivers/input/fixp-arith.h        |   87 ------------------------------------
>  drivers/media/video/gspca/ov534.c |   89 ++++++++++++++++++++++++++++++++++++-
>  include/linux/fixp-arith.h        |   87 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 176 insertions(+), 90 deletions(-)
>  delete mode 100644 drivers/input/fixp-arith.h
>  create mode 100644 include/linux/fixp-arith.h
> 
> -- 
> Antonio Ospite
> http://ao2.it
> 
> A: Because it messes up the order in which people normally read text.
>    See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?

-- 
Dmitry
