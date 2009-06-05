Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39571 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752642AbZFEIm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 04:42:26 -0400
Date: Fri, 5 Jun 2009 09:42:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Don't advertise i2c functions when not available
Message-ID: <20090605084226.GA17158@rakim.wolfsonmicro.main>
References: <20090527070850.GA11221@linux-sh.org> <20090527091831.26b60d6d@hyperion.delvare> <20090527120140.GC1970@sirena.org.uk> <20090602091229.0810f54b@hyperion.delvare> <20090602093431.GA19390@rakim.wolfsonmicro.main> <20090605101330.2f93e9ab@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605101330.2f93e9ab@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 05, 2009 at 10:13:30AM +0200, Jean Delvare wrote:

> Surround i2c function declarations with ifdefs, so that they aren't
> advertised when i2c-core isn't actually built. That way, drivers using
> these functions unconditionally will result in an immediate build
> failure, rather than a late linking failure which is harder to figure
> out.

Thanks!
