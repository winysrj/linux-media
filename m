Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2HLRsy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 13:48:54 -0400
Message-ID: <5027EC7B.5010009@redhat.com>
Date: Sun, 12 Aug 2012 14:48:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: suitable IOCTL error code when device is in state IOCTL cannot
 performed
References: <5027DC16.8050604@iki.fi>
In-Reply-To: <5027DC16.8050604@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2012 13:38, Antti Palosaari escreveu:
> Subject says it all. Which one error value is most suitable / generic ?
> 
> Here are few ones I found which could be possible:
> 
> #define EPERM        1  /* Operation not permitted */
> #define EAGAIN      11  /* Try again */
> #define EACCES      13  /* Permission denied */
> #define EBUSY       16  /* Device or resource busy */
> #define ENODATA     61  /* No data available */
> #define ECANCELED   125 /* Operation Canceled */

IMHO, EAGAIN, EBUSY or ENODATA are the most pertinent ones.

Regards,
Mauro
