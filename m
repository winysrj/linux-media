Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56950 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2HGMsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 08:48:41 -0400
Received: by ghrr11 with SMTP id r11so3601313ghr.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 05:48:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208070826.20796.hverkuil@xs4all.nl>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
	<201208070826.20796.hverkuil@xs4all.nl>
Date: Tue, 7 Aug 2012 08:48:41 -0400
Message-ID: <CAGoCfizCV4Qp+a-Ay298CxZPcRmQ+BZ+0MjizHHFheo2qx1-mg@mail.gmail.com>
Subject: Re: [PATCH 00/24] Various HVR-950q and xc5000 fixes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2012 at 2:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Since you're working on the au0828 would it perhaps be possible to have that
> driver use unlocked_ioctl instead of ioctl? It would be really nice if we
> can get rid of the ioctl v4l2_operation at some point in the future.

Hi Hans,

I'm pretty sure that actually got done implicitly by patch #8 as a
result of a fix for a race condition at startup.  Please take a look
and let me know if I missed anything:

[PATCH 08/24] au0828: fix race condition that causes xc5000 to not
bind for digital

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
