Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37635 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbcHOHeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 03:34:08 -0400
Subject: Re: [PATCH v9 0/2] [media] atmel-isc: add driver for Atmel ISC
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@atmel.com,
	robh@kernel.org
References: <1470899202-13933-1-git-send-email-songjun.wu@microchip.com>
Cc: laurent.pinchart@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, linux-kernel@vger.kernel.org,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <676111f8-e179-b2cc-4792-cd4304995e31@xs4all.nl>
Date: Mon, 15 Aug 2016 09:34:02 +0200
MIME-Version: 1.0
In-Reply-To: <1470899202-13933-1-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2016 09:06 AM, Songjun Wu wrote:
> The Image Sensor Controller driver includes two parts.
> 1) Driver code to implement the ISC function.
> 2) Device tree binding documentation, it describes how
>    to add the ISC in device tree.

So close...

Running checkpatch gives me:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#133:
new file mode 100644

Can you make a patch adding an entry to MAINTAINERS? No need to repost the other
two.

Regards,

	Hans
