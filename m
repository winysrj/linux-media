Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992CEC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F42B206B8
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=horus.com header.i=@horus.com header.b="fR23vHx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfC0PRs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:17:48 -0400
Received: from mail.horus.com ([78.46.148.228]:34173 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbfC0PRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:17:48 -0400
Received: from [192.168.1.20] (62-116-61-196.adsl.highway.telekom.at [62.116.61.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "E-Mail Matthias Reichl", Issuer "HiassofT CA 2014" (verified OK))
        by mail.horus.com (Postfix) with ESMTPSA id B6E9D6420A;
        Wed, 27 Mar 2019 16:17:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=horus.com;
        s=20180324; t=1553699866;
        bh=F20ppIz0+VMzwQehJJy0OWkXDKYUVV3xAwMAwuMXfmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fR23vHx2gOicM+zrjks2fyVsz7kmhEBKmDNFmv0g9C7rZvg9soeyRcrz10pJTOogm
         wLGAp0QhS8FDInbp25IHlnpCUkaByCGeIKXEb8GHoQEE/LZ/Qm0upIZcSIhwvHQoG9
         3Ta2GXo0l+EUZAZacrAGrCNCkr6bhjlxBCiywkxI=
Received: by camel2.lan (Postfix, from userid 1000)
        id 7769B1C72C8; Wed, 27 Mar 2019 16:17:45 +0100 (CET)
Date:   Wed, 27 Mar 2019 16:17:45 +0100
From:   Matthias Reichl <hias@horus.com>
To:     Benjamin Valentin <benpicco@googlemail.com>
Cc:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: xbox_remote: add protocol and set timeout
Message-ID: <20190327151745.5beeycfwuf4uz3f7@camel2.lan>
References: <20190324094351.5584-1-hias@horus.com>
 <20190326000704.33fbfac3@rechenknecht2k11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326000704.33fbfac3@rechenknecht2k11>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 26, 2019 at 12:07:04AM +0100, Benjamin Valentin wrote:
> Nice! With this applied the remote feels a lot more snugly.
> 
> In the forum thread you talked about a toggle bit to distiguish new
> button presses from held down buttons.
> The packet send by the Xbox Remote includes how much time has passed
> since the last packet was sent.
> 
> u16 last_press_ms = le16_to_cpup((__le16 *)(data + 4));
> 
> If the button was held down, this value will always be 64 or 65 ms, if
> the button was released in between, it will be higher than that.
> (If you leave the remote idle, it will count to 65535 and stop there)
> 
> Maybe this is helpful, I'm not sure what's the right knob to turn with
> this information.
> 
> Anyway, thank you a lot for the fix!

Thanks a lot for testing!

And also thanks a lot for the info on the last_press_ms field,
I had already been wondering which values it'd contain.

It seems that doesn't add much info that we already have from the
current system time - and as the key handling uses timers using
the delays provided last_press_ms would be tricky too.

Every time the driver calls rc_keydown a timer is armed to fire
after 74ms (64ms period plus 10ms timeout). If another scancode
is received within that time the timer is re-armed. If the timer
expires a keyup event is sent to the linux input layer.

So the current implementation in the driver is very close to the
optimum, timing wise.

The toggle bit of eg the rc-5 and rc-6 protocols can help when
dealing with very long timeouts (eg 100-200ms) as people can easily
press faster than the (about 200-300-ms) total timeout. With the
toggle bit repeated button presses can be reliably distinguished
from long ones.

With the recent optimizations in rc core the toggle bit has become
less important than before, as now rc core tries to set the timeout
as low as possible. For some IR receivers which don't support
low timeout values the toggle bit is still quite useful, though.

so long,

Hias

> 
> Acked-by: Benjamin Valentin <benpicco@googlemail.com>
