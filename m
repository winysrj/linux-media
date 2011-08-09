Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58966 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab1HIKph (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 06:45:37 -0400
Message-ID: <4E410FCE.7080701@iki.fi>
Date: Tue, 09 Aug 2011 13:45:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: linux-media@vger.kernel.org, Robert Schlabbach <robert_s@gmx.net>
Subject: Re: [PATCH v2] CXD2820R: Replace i2c message translation with repeater
 gate control
References: <4E406E53.6050302@iki.fi> <1312884981-15835-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1312884981-15835-1-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>


On 08/09/2011 01:16 PM, Steve Kerrison wrote:
> This patch implements an i2c_gate_ctrl op for the cxd2820r. Thanks to Robert
> Schlabbach for identifying the register address and field to set.
> 
> The old i2c intercept code that prefixed messages with a passthrough byte has
> been removed and the PCTV nanoStick T2 290e entry in em28xx-dvb has been
> updated appropriately.
> 
> Tested for DVB-T2 use; I would appreciate it if somebody with DVB-C capabilities
> could test it as well - from inspection I cannot see any problems.
> 
> This is patch v2. It fixes some schoolboy style errors and removes superfluous
> i2c entries in cxd2820r.h.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>

-- 
http://palosaari.fi/
