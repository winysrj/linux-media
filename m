Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45627 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2LDQRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:17:53 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so3189151vcd.19
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2012 08:17:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
References: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
Date: Tue, 4 Dec 2012 11:17:51 -0500
Message-ID: <CAGoCfixR7oANQM4SoUBY1qpGt=Y4PedD85G+SXncg4ab9YiRng@mail.gmail.com>
Subject: Re: [PATCH 1/2] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 4, 2012 at 11:07 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> This patch removes the dependendency of VIDEO_AU0828 on VIDEO_V4L2 by
> creating a new Kconfig option, VIDEO_AU0828_V4L2, which enables analog
> video capture support and depends on VIDEO_V4L2 itself.
>
> With VIDEO_AU0828_V4L2 disabled, the driver will only support digital
> television and will not depend on the v4l2-core. With VIDEO_AU0828_V4L2
> enabled, the driver will be built with the analog v4l2 support included.

Hi Mike,

This is generally good stuff.  A couple of thoughts.

It seems that this driver effectively takes the approach which is the
exact reverse of all the other hybrid drivers - it mandates DVB with
V4L as optional, whereas most of the other drivers mandate V4L with
DVB is optional.  Now I recognize that in this case it was done
because of some specific business need -- however I have to wonder if
the moving around of all the code to no longer be "video" vs. "dvb"
specific could be leveraged to allow users to select either condition
- to select DVB, V4L, or both.

This seems like the direction things are going in -- we've
restructured the tree based on bus interface type (pci/usb/etc) rather
than v4l versus dvb.  This might be an opportunity to define the model
for how other hybrid devices could also be refactored to not have V4L
or DVB if not needed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
