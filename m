Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48665 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2FUOVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 10:21:18 -0400
Received: by mail-gg0-f174.google.com with SMTP id u4so495707ggl.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 07:21:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
Date: Thu, 21 Jun 2012 10:21:18 -0400
Message-ID: <CAGoCfiz=j58Gk=VKuQQ7mnvH+bYGqiuD5amuc-+NHcEvxNk+9g@mail.gmail.com>
Subject: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 21, 2012 at 9:36 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The firmware blob may not be available when the driver probes.
>
> Instead of blocking the whole kernel use request_firmware_nowait() and
> continue without firmware.
>
> This shouldn't be that bad on drx-k devices, as they all seem to have an
> internal firmware. So, only the firmware update will take a little longer
> to happen.

The patch itself looks fine, however the comment at the end probably
isn't valid. Many of the drx-k devices don't have onboard flash, and
even for the ones that do have flash, uploading the firmware doesn't
actually rewrite the flash.  It patches the in-RAM copy (or replaces
the *running* image).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
