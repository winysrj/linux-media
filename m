Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-241.synserver.de ([212.40.185.241]:1064 "EHLO
	smtp-out-208.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751125AbaLRVdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 16:33:21 -0500
Message-ID: <5493485E.7020803@metafoo.de>
Date: Thu, 18 Dec 2014 22:34:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] regmap: pass map name to lockdep
References: <1418936717-2806-1-git-send-email-crope@iki.fi>
In-Reply-To: <1418936717-2806-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2014 10:05 PM, Antti Palosaari wrote:
> lockdep complains recursive locking and deadlock when two different
> regmap instances are called in a nested order. That happen easily
> for example when both I2C client and muxed/repeater I2C adapter are
> using regmap. As a solution, pass regmap name for lockdep in order
> to force lockdep validate regmap mutex per driver - not as all regmap
> instances grouped together.

That's not how it works. Locks are grouped by lock class, the name is just for 
pretty printing. The only reason you do not get a warning anymore is because 
you have now different lock classes one for configs with a name and one for 
configs without a name.

You really need a way to specify a custom lock class per regmap instance in 
order to solve this problem.

- Lars
