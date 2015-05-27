Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbE0KlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 06:41:13 -0400
Message-ID: <55659F3F.5080503@ti.com>
Date: Wed, 27 May 2015 13:41:03 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <vinod.koul@intel.com>, <tony@atomide.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>
Subject: Re: [PATCH 03/13] serial: 8250_dma: Support for deferred probing
 when requesting DMA channels
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com> <20150526144432.GA23156@kroah.com>
In-Reply-To: <20150526144432.GA23156@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2015 05:44 PM, Greg Kroah-Hartman wrote:
> On Tue, May 26, 2015 at 04:25:58PM +0300, Peter Ujfalusi wrote:
>> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
>> channels. In case of error, return the error code we received including
>> -EPROBE_DEFER
> 
> I think you typed the function name wrong here :(

Oops. Also in other drivers :(
I will fix up the messages for the v2 series, which will not going to include
the patch against 8250_dma.

If I understand things right around the 8250_* is that the
serial8250_request_dma() which is called from serial8250_do_startup() is not
called at module probe time, so it can not be used to handle deferred probing.

Thus this patch can be dropped IMO.

-- 
Péter
