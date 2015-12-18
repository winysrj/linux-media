Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:54298 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964957AbbLRTm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 14:42:59 -0500
Subject: Re: Automatic device driver back-porting with media_build
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <5672A6F0.6070003@free.fr> <20151217105543.13599560@recife.lan>
 <5672BE15.9070006@free.fr> <20151217120830.0fc27f01@recife.lan>
 <5672C713.6090101@free.fr> <20151217125505.0abc4b40@recife.lan>
 <56743DF7.2040904@free.fr>
From: Mason <slash.tmp@free.fr>
Message-ID: <567461B9.2070704@free.fr>
Date: Fri, 18 Dec 2015 20:42:49 +0100
MIME-Version: 1.0
In-Reply-To: <56743DF7.2040904@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2015 18:10, Mason wrote:

> Am I doing something wrong?

Yes, I didn't have I2C enabled.

By running 'make menuconfig' in a recent kernel, I could see which
Kconfig options are required to build the dvbsky driver.

Mauro, I hope you'll find time to address my remaining bug reports.

Issue #1
check_files_for_func("writel_relaxed", "NEED_WRITEL_RELAXED", "include/asm-generic/io.h");
is definitely incorrect for older kernels.

Issue #2
WARNING: "nsecs_to_jiffies" [/tmp/sandbox/media_build/v4l/gpio-ir-recv.ko] undefined!

Regards.

