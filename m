Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60280 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2FKISG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:18:06 -0400
Received: by obbtb18 with SMTP id tb18so6418335obb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 01:18:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 16:18:06 +0800
Message-ID: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
Subject: extend v4l2_mbus_framefmt
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi and Hans,

We use v4l2_mbus_framefmt to get frame format on the media bus in
bridge driver. It only contains width and height. It's not a big
problem in SD. But we need more info like front porch, sync width and
back porch (similar to disp_format_s in v4l2_formats.h) in HD. I want
to add these fields in v4l2_mbus_framefmt or do you have any better
solution?

Thanks,
Scott
