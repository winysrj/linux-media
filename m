Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33213 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbeKBAKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Nov 2018 20:10:41 -0400
Date: Thu, 1 Nov 2018 15:07:17 +0000
From: Sean Young <sean@mess.org>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] media: rc: self test for IR encoders and decoders
Message-ID: <20181101150717.5nriiopjujhqpaj3@gofer.mess.org>
References: <20181016140931.21097-1-sean@mess.org>
 <cc852823-687a-4cbf-288b-99030462ce21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc852823-687a-4cbf-288b-99030462ce21@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thu, Nov 01, 2018 at 08:59:39AM -0600, Shuah Khan wrote:
> On 10/16/2018 08:09 AM, Sean Young wrote:
> > ir-loopback can transmit IR on one rc device and check the correct
> > scancode and protocol is decoded on a different rc device. This can be
> > used to check IR transmission between two rc devices. Using rc-loopback,
> > we use it to check the IR encoders and decoders themselves.
> > 
> > No hardware is required for this test.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > Cc: Shuah Khan <shuah@kernel.org>
> 
> Hi Sean,
> 
> This looks good. I will get this into the next release. It will show
> up in linux-kselftest next after 4.20-rc1 comes out.

Great, thank you very much.

Regards,

Sean
