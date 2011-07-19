Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:17861 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1GSTX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 15:23:26 -0400
Message-ID: <4E25D9B8.9070109@iki.fi>
Date: Tue, 19 Jul 2011 22:23:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Subject: Re: [RFC PATCH 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware support
 module
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com> <1309439597-15998-2-git-send-email-manjunath.hadli@ti.com> <20110713185050.GC27451@valkosipuli.localdomain> <B85A65D85D7EB246BE421B3FB0FBB593024BCEF740@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF740@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hadli, Manjunath wrote:
> Sakari, Thank you for your comments. I agree with them and fix.
> Please comment
on the rest of the patches as well.
> -Manju>

Hi Manju,

I'll attempt to find more time for this.

[clip]

>>> +/* CFG1 Masks and shifts */
>>> +#define ONESHOT_SHIFT                      (0)
>>> +#define DECIM_SHIFT                        (1)
>>> +#define INPSRC_SHIFT                       (2)
>>> +#define CLKDIV_SHIFT                       (4)
>>> +#define AVGFILT_SHIFT                      (7)
>>> +#define PACK8IN_SHIFT                      (8)
>>> +#define IALAW_SHIFT                        (9)
>>> +#define CLKSEL_SHIFT                       (10)
>>> +#define DATASFT_SHIFT                      (11)
>>> +#define INPSRC1_SHIFT                      (14)
>>
>> IPIPEIF prefix. Are these related to a particular register or a set of registers?
> One register. Will need to add the IPIPEIF prefix.

Assuming CFG1 is the name of the register, what about IPIPEIF_CFG1_...?

>>> +/* DPC2 */
>>> +#define IPIPEIF_DPC2_EN_SHIFT              (12)
>>> +#define IPIPEIF_DPC2_THR_MASK              (0xFFF)
>>> +#define IPIPEIF_DF_GAIN_EN_SHIFT   (10)
>>> +#define IPIPEIF_DF_GAIN_MASK               (0x3FF)
>>> +#define IPIPEIF_DF_GAIN_THR_MASK   (0xFFF)

Also all of these should have DPC2 prefix before DPC2 if they're all for
the same register.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
