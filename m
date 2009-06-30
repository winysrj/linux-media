Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41432 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751716AbZF3LDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 07:03:01 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Tue, 30 Jun 2009 13:03:00 +0200
References: <200906281514.10689.PeterHuewe@gmx.de> <200906291322.05379.PeterHuewe@gmx.de> <20090630122611.108b4106@free.fr>
In-Reply-To: <20090630122611.108b4106@free.fr>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301303.01740.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag 30 Juni 2009 12:26:11 schrieben Sie:

> What is sure is that skype has no problem. It is a loader problem.
>
> May you check the type of /usr/lib32/libv4l/v4l1compat.so?
>
> And, also, what gives 'ldd /opt/skype/skype'?
>
> Cheers.



Hi,

d'oh :) - 
file  /usr/lib32/libv4l/v4l1compat.so -> No such file or directory

After I compiled the v4l in 32 bit mode for my machine, skype _WORKS_ again 
and it seems the picture is _even better_ than before!
Unfortunately gentoo did not built the 32 bit version itself, which is usually 
the case.

I'm really sorry for blaming the driver, skype while it was only my fault - 
mea culpa.

Thank you very much for your support and your great work - you made my day :)


Peter





