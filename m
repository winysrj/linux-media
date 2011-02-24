Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47572 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1BXVhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 16:37:24 -0500
Received: by fxm17 with SMTP id 17so1024082fxm.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 13:37:23 -0800 (PST)
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Edward Hervey <bilboed@gmail.com>
To: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Date: Thu, 24 Feb 2011 22:36:37 +0100
In-Reply-To: <1298578789.821.54.camel@deumeu>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	 <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	 <201102100847.15212.hverkuil@xs4all.nl>
	 <201102171448.09063.laurent.pinchart@ideasonboard.com>
	 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	 <1298578789.821.54.camel@deumeu>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1298583398.821.58.camel@deumeu>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-02-24 at 21:19 +0100, Edward Hervey wrote:
> 
>   Will GStreamer be as cpu/memory efficient as a pure OMX solution ?
> No,
> I seriously doubt we'll break down all the fundamental notions in
> GStreamer to make it use 0 cpu when running some processing. 

  I blame late night mails...

  I meant "Will GStreamer be capable of zero-cpu usage like OMX is
capable in some situation". The answer still stands.

  But regarding memory usage, GStreamer can do zero-memcpy provided the
underlying layers have a mechanism it can use.

   Edward


