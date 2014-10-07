Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3905 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaJGOMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 10:12:03 -0400
Message-ID: <5433F48B.6070803@xs4all.nl>
Date: Tue, 07 Oct 2014 16:11:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Niels Ole Salscheider <niels_ole@salscheider-online.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] qv4l2: Fix out-of-source build
References: <1412690293-30841-1-git-send-email-niels_ole@salscheider-online.de>
In-Reply-To: <1412690293-30841-1-git-send-email-niels_ole@salscheider-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied.

Thanks!

	Hans

On 10/07/14 15:58, Niels Ole Salscheider wrote:
> Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
> ---
>  utils/qv4l2/Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
> index 26f8dca..2b3251c 100644
> --- a/utils/qv4l2/Makefile.am
> +++ b/utils/qv4l2/Makefile.am
> @@ -8,7 +8,7 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp capture-win.c
>  nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
>  qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
>    ../libmedia_dev/libmedia_dev.la
> -qv4l2_CPPFLAGS = -I../v4l2-compliance -I../v4l2-ctl
> +qv4l2_CPPFLAGS = -I$(srcdir)/../v4l2-compliance -I$(srcdir)/../v4l2-ctl
>  
>  if WITH_QTGL
>  qv4l2_CPPFLAGS += $(QTGL_CFLAGS)
> 

