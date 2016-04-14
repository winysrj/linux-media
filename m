Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56914 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbcDNORb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 10:17:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Songjun Wu <songjun.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Benoit Parrot <bparrot@ti.com>,
	Kumar Gala <galak@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Richard =?ISO-8859-1?Q?R=F6jfors?= <richard@puffinpack.se>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] [media] atmel-isc: add driver for Atmel ISC
Date: Thu, 14 Apr 2016 17:17:37 +0300
Message-ID: <3857132.BKDS7IHZFq@avalon>
In-Reply-To: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
References: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Songjun,

On Wednesday 13 Apr 2016 15:44:18 Songjun Wu wrote:
> The Image Sensor Controller driver includes two parts.
> 1) Driver code to implement the ISC function.
> 2) Device tree binding documentation, it describes how
>    to add the ISC in device tree.
> 
> 
> Songjun Wu (2):
>   [media] atmel-isc: add the Image Sensor Controller code
>   [media] atmel-isc: DT binding for Image Sensor Controller driver

I can't see the second patch in the linux-media mailing list archives, could 
you please resend it ?

>  .../devicetree/bindings/media/atmel-isc.txt        |   84 ++
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/atmel/Kconfig               |    9 +
>  drivers/media/platform/atmel/Makefile              |    3 +
>  drivers/media/platform/atmel/atmel-isc-regs.h      |  280 ++++
>  drivers/media/platform/atmel/atmel-isc.c           | 1537 ++++++++++++++++
>  7 files changed, 1916 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
>  create mode 100644 drivers/media/platform/atmel/Kconfig
>  create mode 100644 drivers/media/platform/atmel/Makefile
>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c

-- 
Regards,

Laurent Pinchart

