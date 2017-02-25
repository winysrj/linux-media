Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60846 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751365AbdBYPdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 10:33:14 -0500
Date: Sat, 25 Feb 2017 16:55:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, CARLOS.PALMINHA@synopsys.com,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v9 1/2] Add OV5647 device tree documentation
Message-ID: <20170225145504.b66vvsi6hiilmaj2@ihha.localdomain>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
 <dd33c7bc-e6f7-c234-c3c6-6cc4c7353c68@mentor.com>
 <a2887a9a-0317-eb89-b971-9b238a214459@synopsys.com>
 <cc6c914e-c3e7-7703-0405-104e701610cf@mentor.com>
 <20170221214813.GN16975@valkosipuli.retiisi.org.uk>
 <1b7e2802-dda1-0372-8738-17655dd8ca69@mentor.com>
 <20170225145053.puqkcrntnhmcvla4@ihha.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225145053.puqkcrntnhmcvla4@ihha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 25, 2017 at 04:50:53PM +0200, Sakari Ailus wrote:
> Although, the driver could try to work on the actual obtained frequency.
> This is unlikely to work though, but it won't be very easy to figure out
> why the device isn't working. Having the frequency in DT accessible for the
> driver to check makes failing early with a clear error message possible.

The below point actually makes the above matter a non-issue: this driver
will contain a list of supported frequencies. A SMIA driver that I
typically work with, for instance, does not. So I think your suggestion of
having the CCF handle setting the frequency is a good one.

> 
> > 
> > So, the clock frequency set up is delegated to CCF, and when any other
> > than 25 MHz frequencies are got supported, that's only the matter of
> > driver updates, DTBs won't be touched.
> 
> Indeed. The new supported frequencies in this case will be additional
> single values; there won't be ranges or such. The register lists the
> driver contains are more or less dependent on that frequency.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
