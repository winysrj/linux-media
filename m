Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36425 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbcEVIdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 04:33:00 -0400
Received: by mail-wm0-f65.google.com with SMTP id q62so7111475wmg.3
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 01:33:00 -0700 (PDT)
Subject: Re: [PATCH 0004/1529] Fix typo
To: Andrea Gelmini <andrea.gelmini@gelma.net>
References: <20160521113606.31494-1-andrea.gelmini@gelma.net>
Cc: trivial@kernel.org, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <57416EB8.9090308@gmail.com>
Date: Sun, 22 May 2016 09:32:56 +0100
MIME-Version: 1.0
In-Reply-To: <20160521113606.31494-1-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/05/16 12:36, Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>   Documentation/DocBook/media/v4l/lirc_device_interface.xml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> index 34cada2..725b221 100644
> --- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> +++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> @@ -114,7 +114,7 @@ on working with the default settings initially.</para>
>         <para>Some receiver have maximum resolution which is defined by internal
>         sample rate or data format limitations. E.g. it's common that signals can
>         only be reported in 50 microsecond steps. This integer value is used by
> -      lircd to automatically adjust the aeps tolerance value in the lircd
> +      lircd to automatically adjust the steps tolerance value in the lircd
>         config file.</para>
>       </listitem>
>     </varlistentry>
>

This is not a typo

auditory evoked potentials (AEPs)

Regards

Malcolm
