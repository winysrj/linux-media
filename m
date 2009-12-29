Return-path: <linux-media-owner@vger.kernel.org>
Received: from common.tnode.com ([91.185.203.243]:51725 "EHLO mail.tnode.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZL2Q56 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 11:57:58 -0500
Message-ID: <4B3A3382.4080203@tnode.com>
Date: Tue, 29 Dec 2009 17:51:14 +0100
From: Mitar <mitar@tnode.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Ondrej Zary <linux@rainbow-software.org>,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
Subject: Re: uvcvideo Logitech patch
References: <4B27DD88.3090900@tnode.com> <200912152215.21467.linux@rainbow-software.org> <200912262048.53769.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200912262048.53769.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Could be, but I'd like to know if increasing the control streaming
> timeout is required as well.

I had some time now and have tested it and it is enough just to increase
UVC_CTRL_STREAMING_TIMEOUT to 5000, I left UVC_CTRL_CONTROL_TIMEOUT at
300. And everything seems to work.


Mitar
