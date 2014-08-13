Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50303 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaHMRbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 13:31:06 -0400
Date: Wed, 13 Aug 2014 18:30:55 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/4] media: rcar_vin: Ensure all in-flight buffers are
 returned to error state before stopping.
Message-Id: <20140813183055.dbc44b7fa03f39aaa8b149c6@codethink.co.uk>
In-Reply-To: <53DFEF99.7040503@cogentembedded.com>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
	<1404812474-7627-3-git-send-email-ian.molton@codethink.co.uk>
	<53DFEF99.7040503@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>     Fixed kernel WARNINGs for me! \o/
>     Ian, perhaps it makes sense for me to take these patches into my hands?

I'm planning to respin these tomorrow - is that OK? I have test hardware with two different frontends here.

-Ian
