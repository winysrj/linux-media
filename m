Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:59398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBZJDC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 04:03:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH, RFC 08/30] [media] arv: fix sleep_on race
Date: Wed, 26 Feb 2014 09:57:39 +0100
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <52D90B42.90206@xs4all.nl> <52F4A486.30100@xs4all.nl>
In-Reply-To: <52F4A486.30100@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402260957.40068.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 February 2014, Hans Verkuil wrote:
> On 01/17/2014 11:51 AM, Hans Verkuil wrote:

> >> diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
> >> index e346d32d..32f6d70 100644
> >> --- a/drivers/media/platform/arv.c
> >> +++ b/drivers/media/platform/arv.c
> >> @@ -307,11 +307,11 @@ static ssize_t ar_read(struct file *file, char *buf, size_t count, loff_t *ppos)
> >>  	/*
> >>  	 * Okay, kick AR LSI to invoke an interrupt
> >>  	 */
> >> -	ar->start_capture = 0;
> >> +	ar->start_capture = -1;
> > 
> > start_capture is defined as an unsigned. Can you make a new patch that changes
> > the type of start_capture to int?
> > 
> > Otherwise it looks fine.


Sorry for the delay. I've updated the patch now and will send it out today
with the other remaining ones.

	Arnd
