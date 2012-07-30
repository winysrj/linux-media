Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26281 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2G3Izq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 04:55:46 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7Y00HOFU5UNY50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jul 2012 09:56:18 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M7Y001DIU4V8Z10@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jul 2012 09:55:44 +0100 (BST)
Message-id: <50164C0F.8070500@samsung.com>
Date: Mon, 30 Jul 2012 10:55:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hdegoede@redhat.com, hans.verkuil@cisco.com
Subject: Re: [PATCH] media: i.MX27: Fix mx2_emmaprp mem2mem driver clocks.
References: <1343637450-5562-1-git-send-email-javier.martin@vista-silicon.com>
In-reply-to: <1343637450-5562-1-git-send-email-javier.martin@vista-silicon.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/30/2012 10:37 AM, Javier Martin wrote:
> This driver wasn't converted to the new clock framework
> (e038ed50a4a767add205094c035b6943e7b30140).
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  This is broken in current stable 3.5 too. So it should be applied
>  to both stable and 3.6.

The you should add "Cc: stable@vger.kernel.org" line along with
your sign-off, ideally mentioning in the patch description to
what stable kernels it applies, and it would all be handled
automatically.
I guess Mauro is going to add that missing Cc, when applying the
patch though.

--

Regards,
Sylwester
