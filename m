Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755301AbeCHKqI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 05:46:08 -0500
Date: Thu, 8 Mar 2018 07:46:01 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix frame interval enumeration
Message-ID: <20180308074601.77c9e7c1@vento.lan>
In-Reply-To: <20180308073909.6c1e0ac9@vento.lan>
References: <1520499719-23955-1-git-send-email-hugues.fruchet@st.com>
        <20180308073909.6c1e0ac9@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Mar 2018 07:39:09 -0300
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Also, if this function starts returning NULL, I suspect that you also
> need to change ov5640_s_frame_interval(), as currently it is called
> at ov5640_s_frame_interval() as:
> 
> 	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
> 						mode->height, true);
> 
> without checking if the returned value is NULL. Setting
> current_mode to NULL can cause oopses at ov5640_set_mode().

Actually, as ov5640_s_frame_interval() calls ov5640_try_fmt_internal()
first. So, this should never happen.


Thanks,
Mauro
