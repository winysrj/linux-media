Return-path: <mchehab@pedra>
Received: from newsmtp5.atmel.com ([204.2.163.5]:20867 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1FCI5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 04:57:53 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Fri, 3 Jun 2011 16:57:03 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801DAC9AD@penmb01.corp.atmel.com>
In-Reply-To: <201105271549.46099.arnd@arndb.de>
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com> <201105271549.46099.arnd@arndb.de>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <mchehab@redhat.com>, <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	"Haring, Lars" <Lars.Haring@atmel.com>, <ryan@bluewatersys.com>,
	<plagnioj@jcrosoft.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Arnd

On Friday, May 27, 2011 9:50 PM, Arnd Bergmann wrote

>On Friday 27 May 2011, Josh Wu wrote:
>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
>> - Using soc-camera framework with videobuf2 dma-contig allocator
>> - Supporting video streaming of YUV packed format
>> - Tested on AT91SAM9M10G45-EK with OV2640
>> 
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>

> Looks good to me now.

> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thank you very much. I'll send a version 3 code.

Best Regards,
Josh Wu
