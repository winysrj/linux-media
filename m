Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:43117 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2HKUwe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 16:52:34 -0400
Date: Sat, 11 Aug 2012 21:52:32 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] [media] iguanair: Fix return value on transmit
Message-ID: <20120811205232.GA5116@pequod.mess.org>
References: <1344626888-10536-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344626888-10536-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2012 at 08:28:03PM +0100, Sean Young wrote:
> Transmit returned 0 after sending and failed to send anything if the amount
> exceeded its buffer size. Also fix some minor errors.
> 
> Signed-off-by: Sean Young <sean@mess.org>

I'm sorry, this patch series wasn't diffed against the right tree, so it
won't apply. I'll need to rediff and retest. In the mean time any review
comments would be appreciated.


Sean
