Return-path: <linux-media-owner@vger.kernel.org>
Received: from iq.passwd.hu ([217.27.212.140]:55204 "EHLO iq.passwd.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751169AbcISTeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 15:34:04 -0400
Date: Mon, 19 Sep 2016 21:33:57 +0200 (CEST)
From: Marton Balint <cus@passwd.hu>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v4.8] cx23885/saa7134: assign q->dev to the PCI
 device
In-Reply-To: <90368e3b-776e-1e58-77a9-d8ab2e59ef5e@xs4all.nl>
Message-ID: <alpine.LNX.2.00.1609192131230.17398@iq.passwd.hu>
References: <90368e3b-776e-1e58-77a9-d8ab2e59ef5e@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Sun, 18 Sep 2016, Hans Verkuil wrote:

> Fix a regression caused by commit 2bc46b3a (media/pci: convert drivers to use the
> new vb2_queue dev field). Three places where q->dev should be set were missed, causing
> a WARN.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Marton Balint <cus@passwd.hu>
> ---

Tested-by: Marton Balint <cus@passwd.hu>

Thanks, the patch indeed fixes the WARN, and dvbstream is now working 
properly.

Regards,
Marton
