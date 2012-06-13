Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51887 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2FMFbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 01:31:38 -0400
Received: by obbtb18 with SMTP id tb18so355648obb.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 22:31:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206111033.47369.hverkuil@xs4all.nl>
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
	<201206111033.47369.hverkuil@xs4all.nl>
Date: Wed, 13 Jun 2012 13:31:37 +0800
Message-ID: <CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
> gives you the information you need.
>
I can solve this problem in HD, but how about SD? Add a fake
dv_timings ops in SD decoder driver?
