Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:41500 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZANSZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 13:25:13 -0500
Message-ID: <496E2E18.20805@scram.de>
Date: Wed, 14 Jan 2009 19:25:28 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] Add Freescale MC44S803 tuner driver
References: <496E2912.8030604@scram.de> <496E2B96.8060404@iki.fi>
In-Reply-To: <496E2B96.8060404@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

> Now it applies cleanly, but didn't compile.


> /home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c:339: error: 
> 'KERN_ERROR' undeclared (first use in this function)

Ouch, forgot to commit the fix for this typo:

s/KERN_ERROR/KERN_ERR/

v3 will follow.

Thanks,
Jochen
