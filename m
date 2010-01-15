Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:33384 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab0AOOhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 09:37:17 -0500
Received: by ewy1 with SMTP id 1so73078ewy.28
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 06:37:14 -0800 (PST)
Message-ID: <4B507EAA.40607@gmail.com>
Date: Fri, 15 Jan 2010 15:41:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
Subject: V4L/DVB ivtv-yuv.c: args->dst.left assigned to both nf->tru_x and
 nf->dst_x in ivtv_yuv_setup_frame()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vi drivers/media/video/ivtv/ivtv-yuv.c +971

and note that `args->dst.left' is assigned both to
nf->tru_x and nf->dst_x, is that ok?

Roel
