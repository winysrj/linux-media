Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33371 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdKKMEi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 07:04:38 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so8637904wmr.0
        for <linux-media@vger.kernel.org>; Sat, 11 Nov 2017 04:04:38 -0800 (PST)
Received: from [192.168.0.22] ([62.147.246.169])
        by smtp.googlemail.com with ESMTPSA id b36sm10427020edd.67.2017.11.11.04.04.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Nov 2017 04:04:35 -0800 (PST)
Subject: Re: [PATCH 1/2] sdlcam: fix linking
From: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
To: linux-media@vger.kernel.org
References: <20171110160547.32639-1-funman@videolan.org>
Message-ID: <6f4de3ec-17f4-66c5-8a28-dbd403963a62@videolan.org>
Date: Sat, 11 Nov 2017 13:04:34 +0100
MIME-Version: 1.0
In-Reply-To: <20171110160547.32639-1-funman@videolan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2017 05:05 PM, Rafaël Carré wrote:
> ---
>  contrib/test/Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
> index 6a4303d7..0188fe21 100644
> --- a/contrib/test/Makefile.am
> +++ b/contrib/test/Makefile.am
> @@ -37,7 +37,7 @@ v4l2gl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconver
>  
>  sdlcam_LDFLAGS = $(JPEG_LIBS) $(SDL2_LIBS) -lm -ldl -lrt
>  sdlcam_CFLAGS = -I../.. $(SDL2_CFLAGS)
> -sdlcam_LDADD = ../../lib/libv4l2/.libs/libv4l2.a  ../../lib/libv4lconvert/.libs/libv4lconvert.a
> +sdlcam_LDADD = ../../lib/libv4l2/libv4l2.la  ../../lib/libv4lconvert/libv4lconvert.la
>  
>  mc_nextgen_test_CFLAGS = $(LIBUDEV_CFLAGS)
>  mc_nextgen_test_LDFLAGS = $(LIBUDEV_LIBS)
> 

Signed-off-by: Rafaël Carré <funman@videolan.org>
