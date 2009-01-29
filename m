Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZA2VZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 16:25:01 -0500
Date: Thu, 29 Jan 2009 19:24:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
Subject: Re: cx88-dvb broken since 2.6.29-rc1
Message-ID: <20090129192431.46adf0c9@caramujo.chehab.org>
In-Reply-To: <20090129221012.685c239e@hyperion.delvare>
References: <20090129221012.685c239e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 22:10:12 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Hi folks,
> 
> I have a CX88-based DVB-T adapter which worked fine up to 2.6.28 but is
> broken since 2.6.29-rc1 (and not fixed as off 2.6.29-rc3). The problem
> is that /dev/dvb isn't created. Presumably the root cause is the
> following in the kernel logs as the driver is loaded:

I have already a pull request almost ready that will fix this issue. I'll
likely send it today or tomorrow.



Cheers,
Mauro
