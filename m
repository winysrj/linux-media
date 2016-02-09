Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:35854 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbcBIOUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 09:20:18 -0500
Received: by mail-yk0-f178.google.com with SMTP id z7so100311855yka.3
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2016 06:20:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455015598-18805-2-git-send-email-hdegoede@redhat.com>
References: <1455015598-18805-1-git-send-email-hdegoede@redhat.com>
	<1455015598-18805-2-git-send-email-hdegoede@redhat.com>
Date: Tue, 9 Feb 2016 09:20:17 -0500
Message-ID: <CAGoCfiz+qpbyskJJzXgNkTEea5w_6Np1Q7_GgDY53ZMFu=YswQ@mail.gmail.com>
Subject: Re: [PATCH tvtime 2/2] xvoutput: Add support for planar yuv formats
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2016 at 5:59 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> When running on video cards which are using the modesetting driver +
> glamor, or when running under XWayland + glamor, only planar yuv
> formats are supported by the XVideo extension.
>
> This commits adds support for planar yuv formats to tvtime, making it
> works on these kind of video-cards and XWayland.

This is certainly a welcome change.  Does it work with the overlay
though (i.e. hit tab to show the on-screen menu)?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
