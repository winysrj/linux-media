Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61075 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbaBIP1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 10:27:07 -0500
Message-ID: <1391959624.25424.29.camel@x220>
Subject: Re: [PATCH] [media] si4713: Remove "select SI4713"
From: Paul Bolle <pebolle@tiscali.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 16:27:04 +0100
In-Reply-To: <52F79C37.5030000@xs4all.nl>
References: <1391957777.25424.15.camel@x220> <52F79C37.5030000@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Sun, 2014-02-09 at 16:18 +0100, Hans Verkuil wrote:
> USB_SI4713 and PLATFORM_SI4713 both depend on I2C_SI4713. So the select
> should be I2C_SI4713.

Are you sure? I've actually scanned si4713.c before submitting this
patch and I couldn't find anything in it that these other two modules
require. Have I overlooked anything?

>  If you can post a patch fixing that, then I'll pick
> it up for 3.14.
> 
> With the addition of the USB si4713 driver things moved around and were
> renamed, and these selects were missed.

Thanks,


Paul Bolle

