Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753480AbdBUO6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 09:58:35 -0500
Date: Tue, 21 Feb 2017 16:58:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, vladimir_zapolskiy@mentor.com,
        CARLOS.PALMINHA@synopsys.com,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v9 2/2] Add support for OV5647 sensor.
Message-ID: <20170221145829.GK16975@valkosipuli.retiisi.org.uk>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <412e51e695630281d2084a77c0329fd273ea00d7.1487334912.git.roliveir@synopsys.com>
 <20170221120914.GG16975@valkosipuli.retiisi.org.uk>
 <28e7db42-c324-667d-4d76-ad6dc02f0d3b@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28e7db42-c324-667d-4d76-ad6dc02f0d3b@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Tue, Feb 21, 2017 at 02:49:12PM +0000, Ramiro Oliveira wrote:
> Hi Sakari,
> 
> Thank you for your feedback.

You're welcome.

An additional note as you don't implement any controls --- some CSI-2
receivers may need to know the link frequency to know how to program the
receiver; they'll simply fail to start streaming if you don't.

<URL:http://hverkuil.home.xs4all.nl/spec/uapi/v4l/extended-controls.html#image-process-control-reference>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
