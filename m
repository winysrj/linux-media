Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41032 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LaLLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 06:11:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Date: Fri, 31 Dec 2010 12:12:18 +0100
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, aospan@netup.ru
References: <201012310726.31851.liplianin@netup.ru>
In-Reply-To: <201012310726.31851.liplianin@netup.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311212.19715.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Igor,

On Friday 31 December 2010 06:26:31 Igor M. Liplianin wrote:
> It uses STAPL files and programs Altera FPGA through JTAG.
> Interface to JTAG must be provided from main device module,
> for example through cx23885 GPIO.

It might be a bit late for this comment (sorry for not having noticed the 
patch set earlier), but...

Do we really need a complete JTAG implementation in the kernel ? Wouldn't it 
better to handle this in userspace with a tiny kernel driver to access the 
JTAG signals ?

-- 
Regards,

Laurent Pinchart
