Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51837 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbcHLKGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 06:06:51 -0400
Subject: Re: [PATCH] Documentation: add support for V4L touch devices
To: y@shmanahar.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
 <1468876312-24688-1-git-send-email-y>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	Nick Dyer <nick@shmanahar.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b96bd93f-5336-eb88-70dc-4ba4076b9511@xs4all.nl>
Date: Fri, 12 Aug 2016 12:06:45 +0200
MIME-Version: 1.0
In-Reply-To: <1468876312-24688-1-git-send-email-y>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nick,

On 07/18/2016 11:11 PM, y@shmanahar.org wrote:
> From: Nick Dyer <nick@shmanahar.org>
> 
> Signed-off-by: Nick Dyer <nick@shmanahar.org>

I'm missing documentation for the new V4L2_CAP_TOUCH capability and the
V4L2_INPUT_TYPE_TOUCH define.

> diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
> new file mode 100644
> index 0000000..32e21f8
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
> @@ -0,0 +1,78 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-TCH-FMT-DELTA-TU08:

The -DELTA part should be removed here and in tu16.rst.

> +
> +**************************
> +V4L2_TCH_FMT_DELTA_TU08 ('TU08')
> +**************************
> +
> +*man V4L2_TCH_FMT_DELTA_TU08(2)*

Ditto.

Regards,

	Hans
