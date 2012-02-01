Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:51843 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab2BANcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 08:32:36 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=junior)
	by mail81.extendcp.com with esmtpa (Exim 4.77)
	id 1RsaIc-0000cU-DA
	for linux-media@vger.kernel.org; Wed, 01 Feb 2012 13:32:34 +0000
Date: Wed, 1 Feb 2012 13:32:34 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: DVB TS/PES filters
Message-ID: <20120201133234.0b6222bc@junior>
In-Reply-To: <20120126154015.01eb2c18@tiber>
References: <20120126154015.01eb2c18@tiber>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Jan 2012 15:40:15 +0000
Tony Houghton <h@realh.co.uk> wrote:

> I could do with a little more information about DMX_SET_PES_FILTER.
> Specifically I want to use an output type of DMX_OUT_TS_TAP. I believe
> there's a limit on how many filters can be set, but I don't know
> whether the kernel imposes such a limit or whether it depends on the
> hardware, If the latter, how can I read the limit?

Can anyone help me get more information about this (and the "magic
number" pid of 8192 for the whole stream)?
