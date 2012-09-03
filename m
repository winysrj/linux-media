Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:51018 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2ICN1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:27:51 -0400
Message-ID: <5044B04F.6080108@smartjog.com>
Date: Mon, 03 Sep 2012 15:27:43 +0200
From: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] ds3000: properly report firmware loading
 issues
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com> <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com> <503F6D18.2060804@iki.fi> <503F84F5.9010304@smartjog.com> <503F8E14.4010006@iki.fi>
In-Reply-To: <503F8E14.4010006@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2012 06:00 PM, Antti Palosaari wrote:
> hmm, looks like ds3000_readreg() logic is still a little bit broken. It
> checks count of sent messages and compares it to 2. But if I2C-adapter
> sends only 1 message or 3 (which should not be possible) function return
> that count instead of -EREMOTEIO. OK, quite rare situation, but one
> point more to fail if I2C-adapter has also bug.

You're absolutely right. The logic is completely awkward. I'm currently
working on a new patch series that will clean up all the register
reading/writing functions to properly check i2c_transfer()'s return code.

> But that happens for return value 0 too. Could it be the issue?
> I2C-adapter returns 0 for some reason? Bug in I2C-adapter with bug in
> ds3000_readreg() implementation?
[...]
> You basically see two different kind of errors, 1) bus communication
> fails, eg. usb timeouts. 2) chips returns error status. Later cases the
> error could come from the this could come from the firmware if chip uses
> firmware or from the silicon. It could be from the I2C-adapter firmware.

Right now, I just have no idea. Right now, the overwhelming majority of
the cards we tested with a recent kernel (about 60 units) are working
just fine with the code as-is.

My main (if not sole) objective for now is to make it easier for us (but
hopefully for others too) to find defective cards/chips.

> Add sleep after the each operation. Good place to add sleep is
> I2C-adapter. I2C-adapters usually supports two different operations,
> write and read + write using repeated START condition. Former us used
> typically for register write and later for register read.
> 
> 500us is good choice. If it is only that one register read which causes
> problems, how about repeating it?

I'll first see how our units are behaving with the upcoming patches but
I'll definitely keep this in mind as a next step.

Thanks again,

Rémi
