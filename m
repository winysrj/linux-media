Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2191 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2HAGmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 02:42:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: Update VIP to videobuf2 and control framework
Date: Wed, 1 Aug 2012 08:41:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208010841.56941.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue July 31 2012 22:17:06 Federico Vaga wrote:
> As suggested I moved the Video Buffer Input (VIP) of the STA2X11 board to the
> videobuf2. This patch series is an RFC.

Thank you very much for working on this! Much appreciated!

> The first patch is just an update to the adv7180 because the VIP (the only
> user) now use the control framework so query{g_|s_|ctrl} are not necessery.

For this patch:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> The second patch adds a new memory allocator for the videobuf2. I name it
> videobuf2-dma-streaming but I think "streaming" is not the best choice, so
> suggestions are welcome. My inspiration for this buffer come from
> videobuf-dma-contig (cached) version. After I made this buffer I found the
> videobuf2-dma-nc made by Jonathan Corbet and I improve the allocator with
> some suggestions (http://patchwork.linuxtv.org/patch/7441/). The VIP doesn't
> work with videobu2-dma-contig and I think this solution is easier the sg.

I leave this to the vb2 experts. It's not obvious to me why we would need
a fourth memory allocator.

> The third patch updates the VIP to videobuf2 and control framework. I made also
> some restyling to the driver and change some mechanism so I take the ownership
> of the driver and I add the copyright of ST Microelectronics. Some trivial
> code is unchanged. The patch probably needs some extra update.
> I add the control framework to the VIP but without any control. I add it to 
> inherit controls from adv7180.

Did you run the latest v4l2-compliance tool from the v4l-utils.git repository
over your driver? I'm sure you didn't since VIP is missing support for control
events and v4l2-compliance would certainly complain about that.

Always check with v4l2-compliance whenever you make changes! It's continuously
improved as well, so a periodic check wouldn't hurt.

Also take a look at the new vb2 helper functions in media/videobuf2-core.h:
it is likely that you can use those to simplify your driver. They are used in
e.g. vivi, so take a look there.

Regards,

	Hans
