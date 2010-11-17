Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:54619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934199Ab0KQIX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 03:23:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 01/15] v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
Date: Wed, 17 Nov 2010 09:23:53 +0100
Cc: linux-media@vger.kernel.org
References: <cover.1289944159.git.hverkuil@xs4all.nl> <a93918cdde57ca474d76262f460ffb3976caf313.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <a93918cdde57ca474d76262f460ffb3976caf313.1289944160.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170923.53792.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010 22:55:32 Hans Verkuil wrote:
> Where reasonable use mutex_lock_interruptible instead of mutex_lock.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Acked-by: Arnd Bergmann <arnd@arndb.de>
