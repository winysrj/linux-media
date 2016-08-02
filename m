Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35535 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935280AbcHBQNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 12:13:04 -0400
Received: by mail-wm0-f47.google.com with SMTP id f65so415491015wmi.0
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2016 09:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160802111129.10826-1-baolex.ni@intel.com>
References: <20160802111129.10826-1-baolex.ni@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Aug 2016 09:07:30 -0700
Message-ID: <CAGXu5jKf9veNb720fQfviQeqbpk3uWa0KX0g5PPSaNMTc4018Q@mail.gmail.com>
Subject: Re: [PATCH 0435/1285] Replace numeric parameter like 0444 with macro
To: Baole Ni <baolex.ni@intel.com>,
	Greg KH <gregkh@linuxfoundation.org>
Cc: mchehab@kernel.org, maurochehab@gmail.com, mchehab@infradead.org,
	mchehab@redhat.com, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	hverkuil@xs4all.nl, a.hajda@samsung.com,
	Borislav Petkov <bp@alien8.de>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, javier@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	prabhakar.csengg@gmail.com, chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are so many of these, I wonder if it'd be better to just do one
giant patch, or at least break them up by subsystem instead of by
individual source file...

-Kees

On Tue, Aug 2, 2016 at 4:11 AM, Baole Ni <baolex.ni@intel.com> wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.
>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>
> ---
>  drivers/media/i2c/tvp5150.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 0b6d46c..d8ffd88 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -33,7 +33,7 @@ MODULE_LICENSE("GPL");
>
>
>  static int debug;
> -module_param(debug, int, 0644);
> +module_param(debug, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(debug, "Debug level (0-2)");
>
>  struct tvp5150 {
> --
> 2.9.2
>



-- 
Kees Cook
Chrome OS & Brillo Security
