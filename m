Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47993 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbcERQhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 12:37:39 -0400
Date: Wed, 18 May 2016 11:37:32 -0500
From: Rob Herring <robh@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: mark.rutland@arm.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH v2 4/6] ir-rx51: add DT support to driver
Message-ID: <20160518163732.GA25142@rob-hp-laptop>
References: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1463427254-7728-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463427254-7728-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 16, 2016 at 10:34:12PM +0300, Ivaylo Dimitrov wrote:
> With the upcoming removal of legacy boot, lets add support to one of the
> last N900 drivers remaining without it. As the driver still uses omap
> dmtimer, add auxdata as well.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  .../devicetree/bindings/media/nokia,n900-ir          | 20 ++++++++++++++++++++
>  arch/arm/mach-omap2/pdata-quirks.c                   |  6 +-----
>  drivers/media/rc/ir-rx51.c                           | 11 ++++++++++-
>  3 files changed, 31 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir

Acked-by: Rob Herring <robh@kernel.org>
