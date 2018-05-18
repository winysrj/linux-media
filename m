Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50728 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752536AbeEROEk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:04:40 -0400
Date: Fri, 18 May 2018 16:04:35 +0200
From: Ana Guerrero Lopez <ana.guerrero@collabora.com>
To: ming_qian@realsil.com.cn
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: media: uvcvideo: Support realtek's UVC 1.5 device
Message-ID: <20180518140435.GA17444@delenn>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 09, 2018 at 10:13:08AM +0800, ming_qian@realsil.com.cn wrote:
> From: ming_qian <ming_qian@realsil.com.cn>
> 
> The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
> Change it to 48 for UVC 1.5 device,
> and the UVC 1.5 device can be recognized.
> 
> More changes to the driver are needed for full UVC 1.5 compatibility.
> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
> been reported to work well.
> 
> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Josef Šimánek <josef.simanek@gmail.com>

It works perfectly here on 4.16.5 with a Dell XPS 9370 in Debian.

Tested-by: Ana Guerrero Lopez <ana.guerrero@collabora.com>

Cheers,
Ana
