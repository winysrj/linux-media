Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbeKBAD0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Nov 2018 20:03:26 -0400
Subject: Re: [PATCH] media: rc: self test for IR encoders and decoders
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20181016140931.21097-1-sean@mess.org>
Cc: Shuah Khan <shuah@kernel.org>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <cc852823-687a-4cbf-288b-99030462ce21@kernel.org>
Date: Thu, 1 Nov 2018 08:59:39 -0600
MIME-Version: 1.0
In-Reply-To: <20181016140931.21097-1-sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2018 08:09 AM, Sean Young wrote:
> ir-loopback can transmit IR on one rc device and check the correct
> scancode and protocol is decoded on a different rc device. This can be
> used to check IR transmission between two rc devices. Using rc-loopback,
> we use it to check the IR encoders and decoders themselves.
> 
> No hardware is required for this test.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> Cc: Shuah Khan <shuah@kernel.org>

Hi Sean,

This looks good. I will get this into the next release. It will show
up in linux-kselftest next after 4.20-rc1 comes out.

thanks,
-- Shuah
