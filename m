Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51126 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033092AbbKEQLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2015 11:11:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc-core: Remove 'struct timeval' usage
Date: Thu, 05 Nov 2015 17:11:23 +0100
Message-ID: <3925745.FRk6iC2V7r@wuerfel>
In-Reply-To: <20151029071657.GA11549@google.com>
References: <20151029071657.GA11549@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 October 2015 00:16:57 Tina Ruchandani wrote:
> streamzap uses 'struct timeval' to store the start time of a signal for
> gap tracking. struct timeval uses a 32-bit seconds representation which
> will overflow in year 2038 and beyond. Replace struct timeval with ktime_t
> which uses a 64-bit seconds representation and is 2038 safe. This patch 
> uses ktime_get_real() preserving the use of wall-clock time in the 
> original code.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I've applied it to my y2038 tree for the moment, so I won't forget
about it, but it would be nice	if Mauro could pick it up as well and let
me drop it from my tree.

	Arnd
