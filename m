Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:47765 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101Ab2CEVKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 16:10:41 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] radio-isa: PnP support for the new ISA radio framework
Date: Mon, 5 Mar 2012 22:10:23 +0100
Cc: linux-media@vger.kernel.org
References: <201203012025.08605.linux@rainbow-software.org> <201203020955.16196.hverkuil@xs4all.nl> <201203052130.53961.linux@rainbow-software.org>
In-Reply-To: <201203052130.53961.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203052210.26000.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 March 2012 21:30:51 Ondrej Zary wrote:
> Add PnP support to the new ISA radio framework.

[...]

> +int radio_isa_pnp_remove(struct pnp_dev *dev)

Please ignore this patch, it's broken (this function should return void and 
radio-gemtek fails to compile without CONFIG_PNP). I've sent fixed v2 patch.


-- 
Ondrej Zary
