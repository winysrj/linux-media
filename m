Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58108 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2I0Tl2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 15:41:28 -0400
Message-ID: <5064ABD2.2060106@iki.fi>
Date: Thu, 27 Sep 2012 22:41:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Damien Bally <biribi@free.fr>
CC: linux-media@vger.kernel.org, tvboxspy@gmail.com
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev.
 2
References: <5064A3AD.70009@free.fr>
In-Reply-To: <5064A3AD.70009@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2012 10:06 PM, Damien Bally wrote:
> This patch adds support for new Terratec Cinergy T Stick Dual rev. 2.
>
> Signed-off-by: Damien Bally <biribi@free.fr>

I will NACK that initially because that USB ID already used by AF9015 
driver. You have to explain / study what happens when AF9015 driver 
claims that device same time.

Antti


-- 
http://palosaari.fi/
