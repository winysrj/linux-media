Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46139 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbZHTVet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 17:34:49 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: David Brownell <david-b@pacbell.net>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 20 Aug 2009 16:34:35 -0500
Subject: RE: [PATCH 3/5 - v3] DaVinci: platform changes to support vpfe
 camera capture
Message-ID: <A69FA2915331DC488A831521EAE36FE401548C2C09@dlee06.ent.ti.com>
References: <1250551146-32543-1-git-send-email-m-karicheri2@ti.com>
 <200908191404.16404.david-b@pacbell.net>
In-Reply-To: <200908191404.16404.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David,

Agree. I had posted a query and the suggestion I got was to use the patch for i2c mux support to implement this cleanly. But I didn't hear any plan to add this patch to upstream. This patch is already merged to v4l-dvb. I will work on a separate patch to move this code to a daughter card specific code.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>Sent: Wednesday, August 19, 2009 5:04 PM
>To: davinci-linux-open-source@linux.davincidsp.com
>Cc: Karicheri, Muralidharan; linux-media@vger.kernel.org
>Subject: Re: [PATCH 3/5 - v3] DaVinci: platform changes to support vpfe
>camera capture
>
>On Monday 17 August 2009, m-karicheri2@ti.com wrote:
>>  static struct i2c_board_info dm355evm_i2c_info[] = {
>>         {       I2C_BOARD_INFO("dm355evm_msp", 0x25),
>>                 .platform_data = dm355evm_mmcsd_gpios,
>>         },
>> +       {
>> +               I2C_BOARD_INFO("PCA9543A", 0x73),
>> +       },
>>         /* { plus irq  }, */
>>         /* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
>>  };
>
>The DM355 EVM board has no PCA9543A I2C multiplexor
>chip, so this is not a good approach to use.  (*)
>
>If I understand correctly you are configuring some
>particular add-on board, which uses a chip like that.
>There are at least two such boards today, yes?  And
>potentially more.  Don't preclude (or complicate)
>use of different boards...
>
>The scalable approach is to have a file for each
>daughtercard, and Kconfig options to enable the
>support for those cards.  The EVM board init code
>might call a dm355evm_card_init() routine, and
>provide a weak binding for it which would be
>overridden by the
>
>- Dave
>
>(*) Separate issue:  there's ongoing work to get the
>    I2C stack to support such chips in generic ways;
>    you should plan to use that work, which ISTR wasn't
>    too far from being mergeable.
>

