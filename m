Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52488 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBJKGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:06:32 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so2426143eaj.17
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 02:06:31 -0800 (PST)
Message-ID: <52F8A4A2.9080106@gmail.com>
Date: Mon, 10 Feb 2014 11:06:26 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 00/86] SDR tree
References: <1391935771-18670-1-git-send-email-crope@iki.fi> <52F89F2E.3040902@xs4all.nl>
In-Reply-To: <52F89F2E.3040902@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> First of all, would this work for a rtl2838 as well or is this really 2832u
> specific? I've got a 2838...  If it is 2832u specific, then do you know which
> product has it? It would be useful for me to have a usb stick with which I can
> test SDR.

regarding this question, 2838 is just another USB Id for rtl2832u
devices based on reference design. I have one with rtl2832u + e4000
tuner, so probably your stick is fine for SDR.

Realtek makes several different demodulators with similar codenames:
- 2830/2832 DVB-T
- 2836 DTMB
- 2840 DVB-C

see here for more info:
http://www.realtek.com.tw/products/productsView.aspx?Langid=1&PNid=7&PFid=22&Level=3&Conn=2

Regards,
Gianluca
