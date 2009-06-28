Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46088 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752054AbZF1UvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 16:51:00 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Sun, 28 Jun 2009 22:50:58 +0200
Cc: linux-media@vger.kernel.org
References: <200906281514.10689.PeterHuewe@gmx.de> <20090628201447.792efe63@free.fr>
In-Reply-To: <20090628201447.792efe63@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282250.58652.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Did you use the v4l2 wrapper when running the applications? (look in my
> page for more information)


Hi,
I tried using cheese with 
LD_PRELOAD=/usr/lib64/libv4l/v4l1compat.so - and it works!

However this does not work with skype :/ (skype does not allow preloading)

Any suggestions how I get skype to use the compat wrapper?


Thank you,
Peter
