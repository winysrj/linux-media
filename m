Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S972052AbeEYBFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 21:05:42 -0400
Date: Thu, 24 May 2018 18:05:27 -0700
From: Darren Hart <dvhart@infradead.org>
To: Ana Guerrero Lopez <ana.guerrero@collabora.com>
Cc: ming_qian@realsil.com.cn,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: media: uvcvideo: Support realtek's UVC 1.5 device
Message-ID: <20180525010527.GD10172@fury>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180518140435.GA17444@delenn>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 04:04:35PM +0200, Ana Guerrero Lopez wrote:
> On Wed, May 09, 2018 at 10:13:08AM +0800, ming_qian@realsil.com.cn wrote:
> > From: ming_qian <ming_qian@realsil.com.cn>
> > 
> > The length of UVC 1.5 video control is 48, and it id 34 for UVC 1.1.
> > Change it to 48 for UVC 1.5 device,
> > and the UVC 1.5 device can be recognized.
> > 
> > More changes to the driver are needed for full UVC 1.5 compatibility.
> > However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have
> > been reported to work well.
> > 
> > Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> > Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> > Tested-by: Josef Šimánek <josef.simanek@gmail.com>
> 
> It works perfectly here on 4.16.5 with a Dell XPS 9370 in Debian.
> 
> Tested-by: Ana Guerrero Lopez <ana.guerrero@collabora.com>

I worked with Eilís Ní Fhlannagáin on social media who has also confirmed this to solve
her camera issue with her Dell XPS 13 (I didn't get the specific model).

Took a looking at linux-next today, I didn't see it. Anything else needed to get
this queued up?  We'd love to get this in the 4.18 merge window, and stable if
possible.

-- 
Darren Hart
VMware Open Source Technology Center
