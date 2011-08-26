Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45612 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753085Ab1HZTD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 26 Aug 2011 21:03:53 +0200
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: radio-si470x-usb.c warning: can I remove =?UTF-8?Q?=27buf=27=3F?=
In-Reply-To: <201108251425.37536.hverkuil@xs4all.nl>
References: <201108251425.37536.hverkuil@xs4all.nl>
Message-ID: <b7859e54bc9c2258672ded9be4cd8665@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> While going through the compile warnings generated in the daily build I
> came
> across this one:
> 
> v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c: In function
> 'si470x_int_in_callback':
> v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c:398:16:
warning:
> variable 'buf' set but not used [-Wunused-but-set-variable]
> 
> The 'unsigned char buf[RDS_REPORT_SIZE];' is indeed unused, but can I
just
> remove it? There is this single assignment to buf: 'buf[0] =
RDS_REPORT;'.
> 
> This makes me wonder if it is perhaps supposed to be used after all.
> 
> Please let me know if I can remove it, or if it is a bug that someone
needs
> to fix.

this is an artifact from shifting the rds processing function into
interrupt context.
Yes, this can safely be removed.

Can you do this?

Bye,
Toby

