Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34457 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2LDQZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:25:59 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so3449263lag.19
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2012 08:25:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixR7oANQM4SoUBY1qpGt=Y4PedD85G+SXncg4ab9YiRng@mail.gmail.com>
References: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
	<CAGoCfixR7oANQM4SoUBY1qpGt=Y4PedD85G+SXncg4ab9YiRng@mail.gmail.com>
Date: Tue, 4 Dec 2012 11:25:58 -0500
Message-ID: <CAOcJUbwfV+9+k1ds0WK8KdEfrFncKuVS8U49Vde52-FEjDikSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
From: Michael Krufky <mkrufky@linuxtv.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 4, 2012 at 11:17 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Dec 4, 2012 at 11:07 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> This patch removes the dependendency of VIDEO_AU0828 on VIDEO_V4L2 by
>> creating a new Kconfig option, VIDEO_AU0828_V4L2, which enables analog
>> video capture support and depends on VIDEO_V4L2 itself.
>>
>> With VIDEO_AU0828_V4L2 disabled, the driver will only support digital
>> television and will not depend on the v4l2-core. With VIDEO_AU0828_V4L2
>> enabled, the driver will be built with the analog v4l2 support included.
>
> Hi Mike,
>
> This is generally good stuff.  A couple of thoughts.
>
> It seems that this driver effectively takes the approach which is the
> exact reverse of all the other hybrid drivers - it mandates DVB with
> V4L as optional, whereas most of the other drivers mandate V4L with
> DVB is optional.  Now I recognize that in this case it was done
> because of some specific business need -- however I have to wonder if
> the moving around of all the code to no longer be "video" vs. "dvb"
> specific could be leveraged to allow users to select either condition
> - to select DVB, V4L, or both.
>
> This seems like the direction things are going in -- we've
> restructured the tree based on bus interface type (pci/usb/etc) rather
> than v4l versus dvb.  This might be an opportunity to define the model
> for how other hybrid devices could also be refactored to not have V4L
> or DVB if not needed.

Thanks for your comments, Devin.  I agree with you that it would be
nice to be able to choose to disable DVB just like how we can disable
V4L, but the reason why I did this to V4L first was not simply due to
the business need -- I did this because of how easy it was to do.  The
driver was originally developed as a DVB-only driver, and later analog
support was added to it (by you ;-) ).  As a result, conditionalizing
the analog support was rather easy.  Doing the same for DVB would
probably not be very difficult either, but I also believe in small
patches and gradual changes.

These patches allow us to build the au0828 driver (and its
dependencies) without the need for the v4l-core.  This is especially
helpful when backporting digital support to older kernels without the
need to muck through the v4l2 api changes.

Do you have any issues with these two patches as-is?  Any suggestions?
 If not, is it OK with you if I request that Mauro merge this for v3.9
?

Cheers,

Mike Krufky
