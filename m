Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44385 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKBOAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:00:10 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so9421931wgg.32
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 06:00:08 -0800 (PST)
Message-ID: <545638E5.3010004@googlemail.com>
Date: Sun, 02 Nov 2014 15:00:05 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH] v4l-utils/libdvbv5: restore deleted functions to keep
 API/ABI compatible
References: <1414929719-11748-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414929719-11748-1-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/14 13:01, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> dvb_new_freq_is_needed() was integrated to dvb_new_entry_is_needed(),
> and dvb_scan_add_entry() was added a new parameter.
> As those changes broke API/ABI compatibility,
> restore the original functions.

I suppose you introduced the new functions to generalize the API.
Can't you keep the new functions and make dvb_new_freq_is_needed a thin
wrapper around them?

Thanks,
Gregor
