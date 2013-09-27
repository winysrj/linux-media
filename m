Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3I0Icz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 04:32:55 -0400
Date: Fri, 27 Sep 2013 09:27:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: alsa-devel@alsa-project.org, b43-dev <b43-dev@lists.infradead.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	devicetree@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	e1000-devel@lists.sourceforge.net,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-omap@vger.kernel.org,
	linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
	linux-samsung-soc@vger.kernel.org,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 00/51] DMA mask changes
Message-ID: <20130927082703.GZ25647@n2100.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <CACna6rxkpYzdD8_Jfi22vA2suUa3k-JM65_gCySQpp4crVCoPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rxkpYzdD8_Jfi22vA2suUa3k-JM65_gCySQpp4crVCoPg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 26, 2013 at 10:23:08PM +0200, Rafał Miłecki wrote:
> 2013/9/19 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > This email is only being sent to the mailing lists in question, not to
> > anyone personally.  The list of individuals is far to great to do that.
> > I'm hoping no mailing lists reject the patches based on the number of
> > recipients.
> 
> Huh, I think it was enough to send only 3 patches to the b43-dev@. Like:
> [PATCH 01/51] DMA-API: provide a helper to set both DMA and coherent DMA masks
> [PATCH 14/51] DMA-API: net: b43: (...)
> [PATCH 15/51] DMA-API: net: b43legacy: (...)
> ;)
> 
> I believe Joe has some nice script for doing it that way. When fixing
> some coding style / formatting, he sends only related patches to the
> given ML.

If I did that, then the mailing lists would not get the first patch,
because almost none of the lists would be referred to by patch 1.

Moreover, people complain when they don't have access to the full
patch series - they assume patches are missing for some reason, and
they ask for the rest of the series.
