Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1871 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1H0OdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 10:33:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Subject: Re: radio-si470x-usb.c warning: can I remove 'buf'?
Date: Sat, 27 Aug 2011 16:33:15 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201108251425.37536.hverkuil@xs4all.nl> <b7859e54bc9c2258672ded9be4cd8665@localhost>
In-Reply-To: <b7859e54bc9c2258672ded9be4cd8665@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108271633.15618.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, August 26, 2011 21:03:53 Tobias Lorenz wrote:
> Hi Hans,
> 
> > While going through the compile warnings generated in the daily build I
> > came
> > across this one:
> > 
> > v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c: In function
> > 'si470x_int_in_callback':
> > v4l-dvb-git/drivers/media/radio/si470x/radio-si470x-usb.c:398:16:
> warning:
> > variable 'buf' set but not used [-Wunused-but-set-variable]
> > 
> > The 'unsigned char buf[RDS_REPORT_SIZE];' is indeed unused, but can I
> just
> > remove it? There is this single assignment to buf: 'buf[0] =
> RDS_REPORT;'.
> > 
> > This makes me wonder if it is perhaps supposed to be used after all.
> > 
> > Please let me know if I can remove it, or if it is a bug that someone
> needs
> > to fix.
> 
> this is an artifact from shifting the rds processing function into
> interrupt context.
> Yes, this can safely be removed.
> 
> Can you do this?

Will do. I've just posted a pull request that includes this fix.

Regards,

	Hans
