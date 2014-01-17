Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaAQOYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:24:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] usbvision: drop unused define USBVISION_SAY_AND_WAIT
Date: Fri, 17 Jan 2014 15:24:46 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <52D9058F.9010000@xs4all.nl>
In-Reply-To: <52D9058F.9010000@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171524.47293.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 17 January 2014, Hans Verkuil wrote:
> This define uses the deprecated interruptible_sleep_on_timeout
> function. Since this define is unused anyway we just remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Clearly better than my patch, thanks!
