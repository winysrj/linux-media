Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaBIUyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 15:54:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Sun, 9 Feb 2014 21:53:51 +0100
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <55674412.rAimUmdW3X@wuerfel> <52F4C51A.90002@xs4all.nl>
In-Reply-To: <52F4C51A.90002@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402092153.51781.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 February 2014, Hans Verkuil wrote:
> OK, let's try again. This patch is getting bigger and bigger, but it is always
> nice to know that your ISA card that almost no one else in the world has is really,
> really working well. :-)
> 
> Regards,
> 
>         Hans
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good,

Acked-by: Arnd Bergmann <arnd@arndb.de>
