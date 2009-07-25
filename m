Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2075 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZGYPTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 11:19:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv11 8/8] FM TX: si4713: Add document file
Date: Sat, 25 Jul 2009 17:19:29 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248533862-20860-1-git-send-email-eduardo.valentin@nokia.com> <1248533862-20860-8-git-send-email-eduardo.valentin@nokia.com> <1248533862-20860-9-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1248533862-20860-9-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907251719.29801.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 16:57:42 Eduardo Valentin wrote:
> This patch adds a document file for si4713 device driver.
> It describes the driver interfaces and organization.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  linux/Documentation/video4linux/si4713.txt |  176 ++++++++++++++++++++++++++++
>  1 files changed, 176 insertions(+), 0 deletions(-)
>  create mode 100644 linux/Documentation/video4linux/si4713.txt
> 
> diff --git a/linux/Documentation/video4linux/si4713.txt b/linux/Documentation/video4linux/si4713.txt
> new file mode 100644
> index 0000000..8b97fb6
> --- /dev/null
> +++ b/linux/Documentation/video4linux/si4713.txt
> @@ -0,0 +1,176 @@
> +Driver for I2C radios for the Silicon Labs Si4713 FM Radio Transmitters
> +
> +Copyright (c) 2009 Nokia Corporation
> +Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> +
> +
> +Information about the Device
> +============================
> +This chip is a Silicon Labs product. It is a I2C device, currently on 0×63 address.

Something went wrong here with the i2c address, it should probably be '0x63'.
I don't know whether this is in your original text or whether it got messed
up in some mailer.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
