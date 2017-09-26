Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:48510 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751855AbdI1PWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 11:22:24 -0400
Date: Tue, 26 Sep 2017 14:41:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 09/10] scripts: kernel-doc: parse next structs/unions
Message-ID: <20170926144104.4e8d2db7@lwn.net>
In-Reply-To: <20170926172947.54b88bf5@recife.lan>
References: <cover.1506448061.git.mchehab@s-opensource.com>
        <e0ee97325e570a7f783122c88e152d89c755c254.1506448061.git.mchehab@s-opensource.com>
        <20170926172947.54b88bf5@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Sep 2017 17:29:47 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> This patch actually need a fixup, in order to handle pointer,
> array and bitmask IDs.

Can you send a new series with the fixed patch?

I sure do like the shrinking of kernel-doc that comes with this series!  

Thanks,

jon
