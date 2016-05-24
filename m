Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:52221 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbcEXJS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 05:18:26 -0400
Subject: Re: [PATCH] [media] adv7604: Add support for hardware reset
To: Dragos Bogdan <dragos.bogdan@analog.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1464081202-25043-1-git-send-email-dragos.bogdan@analog.com>
Cc: linux-media@vger.kernel.org
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <57441C5B.6000305@metafoo.de>
Date: Tue, 24 May 2016 11:18:19 +0200
MIME-Version: 1.0
In-Reply-To: <1464081202-25043-1-git-send-email-dragos.bogdan@analog.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 11:13 AM, Dragos Bogdan wrote:
> The part can be reset by a low pulse on the RESET pin (i.e. a hardware reset) with a minimum width of 5 ms. It is recommended to wait 5 ms after the low pulse before an I2C write is performed to the part.
> For safety reasons, the delays will be 10 ms.
> The RESET pin can be tied high, so the GPIO is optional.
> 
> Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>

Patch looks OK. One comment about the commit message, usually this should be
line-wrapped at around 75 characters.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.
