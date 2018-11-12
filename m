Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbeKLUUr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 15:20:47 -0500
Message-ID: <1542018488.2661.30.camel@suse.de>
Subject: Re: [PATCH] media: v4l: v4l2-controls.h must include types.h
From: Jean Delvare <jdelvare@suse.de>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Mon, 12 Nov 2018 11:28:08 +0100
In-Reply-To: <5770340b744926d5abd653a2235f194f58bd97a2.camel@bootlin.com>
References: <20181112110146.5baee2ea@endymion>
         <5770340b744926d5abd653a2235f194f58bd97a2.camel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-12 at 11:03 +0100, Paul Kocialkowski wrote:
> On Mon, 2018-11-12 at 11:01 +0100, Jean Delvare wrote:
> > Fix the following build-time warning:
> > ./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> We already have a similar fix in the media tree:
> https://git.linuxtv.org/media_tree.git/commit/?h=request_api&id=dafb7f9aef2fd44991ff1691721ff765a23be27b
> 
> So it looks like we won't be needing this one!

Perfect, thanks for letting me know and sorry for the noise.

-- 
Jean Delvare
SUSE L3 Support
