Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:35709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbJ0EwL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 00:52:11 -0400
Date: Mon, 26 Oct 2015 22:08:48 -0700 (PDT)
Message-Id: <20151026.220848.1827888098875824300.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com,
	linux-media@vger.kernel.org, linux@arm.linux.org.uk,
	thomas.petazzoni@free-electrons.com, andrew@lunn.ch,
	bhelgaas@google.com, jason@lakedaemon.net
Subject: Re: [PATCH 0/8] add missing of_node_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1445781427-7110-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1445781427-7110-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun, 25 Oct 2015 14:56:59 +0100

> The various for_each device_node iterators performs an of_node_get on each
> iteration, so a break out of the loop requires an of_node_put.
> 
> The complete semantic patch that fixes this problem is
> (http://coccinelle.lip6.fr):
 ...

Series applied, thanks a lot Julia.
