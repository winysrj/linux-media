Return-path: <linux-media-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:47185 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737Ab0AOQGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 11:06:14 -0500
From: Ian Armstrong <mail01@iarmst.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: V4L/DVB ivtv-yuv.c: args->dst.left assigned to both nf->tru_x and nf->dst_x in ivtv_yuv_setup_frame()
Date: Fri, 15 Jan 2010 16:06:12 +0000
Cc: Hans Verkuil <hverkuil@xs4all.nl>, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
References: <4B507EAA.40607@gmail.com>
In-Reply-To: <4B507EAA.40607@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001151606.12421.mail01@iarmst.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 January 2010, Roel Kluin wrote:
> vi drivers/media/video/ivtv/ivtv-yuv.c +971
> 
> and note that `args->dst.left' is assigned both to
> nf->tru_x and nf->dst_x, is that ok?

It's fine. dst_x is used to set a hardware register and may be changed in 
ivtv_yuv_window_setup()

tru_x is never altered & is used in a special condition where the original 
unaltered value is required.

-- 
Ian
