Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52250 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbaJCEyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Oct 2014 00:54:36 -0400
Message-ID: <542E2BF6.2090800@iki.fi>
Date: Fri, 03 Oct 2014 07:54:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?ItCR0YPQtNC4INCg0L7QvNCw0L3RgtC+LCBBcmVNYSBJbmMi?=
	<info@are.ma>, linux-media@vger.kernel.org
CC: =?UTF-8?B?ItCR0YPQtNC4INCg0L7QvNCw0L3RgtC+LCBBcmVNYSBJbmMi?=
	<knightrider@are.ma>, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: Re: [PATCH] pt3 (pci, tc90522, mxl301rf, qm1d1c0042): pt3_unregister_subdev(),
 pt3_unregister_subdev(), cleanups...
References: <1412275758-31340-1-git-send-email-knightrider@are.ma>
In-Reply-To: <1412275758-31340-1-git-send-email-knightrider@are.ma>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2014 09:49 PM, Буди Романто, AreMa Inc wrote:
> DVB driver for Earthsoft PT3 PCIE ISDB-S/T receiver
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Status: stable
>
> Changes:
> - demod & tuners converted to I2C binding model
> - i586 & x86_64 clean compile
> - lightweight & yet precise CNR calculus
> - raw CNR (DVBv3)
> - DVBv5 CNR @ 0.0001 dB (ref: include/uapi/linux/dvb/frontend.h, not 1/1000 dB!)
> - removed (unused?) tuner's *_release()
> - demod/tuner binding: pt3_unregister_subdev(), pt3_unregister_subdev()
> - some cleanups

These drivers are already committed, like you have noticed. There is 
surely a lot of issues that could be improved, but it cannot be done by 
big patch which replaces everything. You need to just take one issue at 
the time, fix/improve it, send patch to mailing list for review. One 
patch per one logical change.

regards
Antti

-- 
http://palosaari.fi/
