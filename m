Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48403 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbeDEV6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 17:58:06 -0400
Date: Thu, 5 Apr 2018 22:58:04 +0100
From: Sean Young <sean@mess.org>
To: Warren Sturm <warren.sturm@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: HVR1600 IR Blaster
Message-ID: <20180405215804.lgu43fbmsif57mfv@gofer.mess.org>
References: <1522953425.28398.4.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1522953425.28398.4.camel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Warren,

On Thu, Apr 05, 2018 at 12:37:05PM -0600, Warren Sturm wrote:
> Is there a way to get the IR Blaster of the HVR1600 card working under
> v4.15+ kernels?
> 
> It seems that lrc_zilog BUGs under 4.15+ and has gone missing in 4.16.

In v4.16, lirc_zilog has been replaced with ir-kbd-i2c, which can now do
IR transmit/blast. Please can you provide dmesg and try IR transmit with
the associated /dev/lirc device (if one exists).

What is the BUG under v4.15?

Thanks

Sean
