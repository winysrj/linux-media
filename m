Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe03.c2i.net ([212.247.154.66]:36225 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756Ab2JBTup (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 15:50:45 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Subject: Re: [PATCH] Add toggle to the tt3650_rc_query function  of the ttusb2 driver
Date: Tue, 2 Oct 2012 21:52:11 +0200
Cc: linux-media@vger.kernel.org
References: <2504977.yNAtCnX8Pk@jar7.dominio>
In-Reply-To: <2504977.yNAtCnX8Pk@jar7.dominio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210022152.11115.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 08 September 2012 19:08:22 Jose Alberto Reguero wrote:
> This patch add the toggle bit to the tt3650_rc_query function of the ttusb2
> driver.
> 
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> 
> Jose Alberto

Hi,

This patch looks OK.

Regarding the TTUSB2 support, I see an issue where the IR polling interference 
with the CAM access. If a IR poll request happens exactly between a write/read 
CAM request, then that CAM request will fail. How can this issue be solved 
without disabling the IR support entirely?

--HPS
