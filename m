Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34763 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdFBJMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 05:12:06 -0400
Received: by mail-lf0-f43.google.com with SMTP id v20so7731901lfa.1
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 02:12:05 -0700 (PDT)
Subject: Re: [PATCH] ALSA: hda - Fix applying MSI dual-codec mobo quirk
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <20170601205850.24993-1-tiwai@suse.de>
 <20170601205850.24993-2-tiwai@suse.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <a6702e31-ba47-e240-8af2-62de74d89c89@cogentembedded.com>
Date: Fri, 2 Jun 2017 12:12:03 +0300
MIME-Version: 1.0
In-Reply-To: <20170601205850.24993-2-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 6/1/2017 11:58 PM, Takashi Iwai wrote:

> The previous commit [63691587f7b0: ALSA: hda - Apply dual-codec quirk
> for MSI Z270-Gaming mobo] attempted to apply the existing dual-codec

    The standard way of citing a commit is: commit 63691587f7b0 ("ALSA: hda - 
Apply dual-codec quirk for MSI Z270-Gaming mobo"), just like in the Fixes: tag.

> quirk for a MSI mobo.  But it turned out that this isn't applied
> properly due to the MSI-vendor quirk before this entry.  I overlooked
> such two MSI entries just because they were put in the wrong position,
> although we have a list ordered by PCI SSID numbers.
>
> This patch fixes it by rearranging the unordered entries.
>
> Fixes: 63691587f7b0 ("ALSA: hda - Apply dual-codec quirk for MSI Z270-Gaming mobo")
> Reported-by: Rudolf Schmidt <info@rudolfschmidt.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
[...]

MBR, Sergei
