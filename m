Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50108 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757185AbcHWNI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:08:26 -0400
Date: Tue, 23 Aug 2016 07:08:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        markus.heiser@darmarit.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160823070818.42ffec00@lwn.net>
In-Reply-To: <20160823060135.GJ24290@phenom.ffwll.local>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
        <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
        <20160822124930.02dbbafc@vento.lan>
        <20160823060135.GJ24290@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 23 Aug 2016 08:01:35 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> I'm also not too sure about whether dma-buf really should be it's own
> subdirectory. It's plucked from the device-drivers.tmpl, I think an
> overall device-drivers/ for all the misc subsystems and support code would
> be better. Then one toc there, which fans out to either kernel-doc and
> overview docs.

I'm quite convinced it shouldn't be.

If you get a chance, could you have a look at the "RFC: The beginning of
a proper driver-api book" series I posted yesterday (yes, I should have
copied more of you, sorry)?  It shows the direction I would like to go
with driver API documentation, and, assuming we go that way, I'd like the
dma-buf documentation to fit into that.

Thanks,

jon
