Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46168 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab2ETUIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 16:08:14 -0400
Message-ID: <4FB94F2C.4050905@iki.fi>
Date: Sun, 20 May 2012 23:08:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>,
	Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
References: <4FB92428.3080201@gmail.com>
In-Reply-To: <4FB92428.3080201@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.05.2012 20:04, poma wrote:
> After hard/cold boot:

> DVB: register adapter0/net0 @ minor: 2 (0x02)
> rtl2832u_frontend_attach:
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> No compatible tuner found

These errors are coming from tuner probe. As it still goes to probing 
and did not jump out earlier when gate is opened it means that demod is 
answering commands but tuner are not.

My guess is that tuner is still on the reset or not powered at all. It 
is almost 100% sure error is wrong tuner GPIO.

regards
Antti
-- 
http://palosaari.fi/
