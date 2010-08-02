Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48645 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0HBKJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 06:09:05 -0400
Received: by ewy23 with SMTP id 23so1248688ewy.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 03:09:04 -0700 (PDT)
Date: Mon, 2 Aug 2010 13:09:52 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L/DVB: radio-si4713: Release i2c adapter in
 driver cleanup paths
Message-Id: <20100802130952.bc968de6.jhnikula@gmail.com>
In-Reply-To: <4C32325E.1060903@gmail.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
	<4C32325E.1060903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 05 Jul 2010 16:28:30 -0300
Mauro Carvalho Chehab <maurochehab@gmail.com> wrote:

> Hi Eduardo,
> 
> Could you please review those two patches?
> 
Hmm.. are these two patches already late for 2.6.36? I have two another
patches to arch/arm/mach-omap2/board-rx51-peripherals.c and
sound/soc/omap/rx51.c that are pending from patch 2/2.


-- 
Jarkko
