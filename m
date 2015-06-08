Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbFHUMk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 16:12:40 -0400
Date: Mon, 8 Jun 2015 13:12:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ksenija =?utf-8?Q?Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
	devel@driverdev.osuosl.org, mchehab@osg.samsung.com,
	jarod@wilsonet.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH] Staging: media: lirc: Replace timeval with
 ktime_t
Message-ID: <20150608201239.GA16736@kroah.com>
References: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
 <3768175.5Bdztn7jIp@wuerfel>
 <CAL7P5j+YfuysVeCyFQZ9DwN872Ke=PyE5fakBjdR-9h4VqN1pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL7P5j+YfuysVeCyFQZ9DwN872Ke=PyE5fakBjdR-9h4VqN1pQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 08, 2015 at 09:37:24PM +0200, Ksenija Stanojević wrote:
> Hi Greg,
> 
> It's been over two weeks that I've sent this patch.  Have you missed it?

Not at all, please look at the output of
	$ ./scripts/get_maintainer.pl --file drivers/staging/media/lirc/lirc_sir.c

To see why I ignored this.

greg k-h
