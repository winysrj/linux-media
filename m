Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55186 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbeLCI3X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:29:23 -0500
Subject: Re: v4l controls API
To: =?UTF-8?Q?Sebastian_S=c3=bcsens?= <su@mycable.de>,
        linux-media@vger.kernel.org
References: <927806392.2404.1543824141142.JavaMail.zimbra@mycable.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc1b8e14-34e8-31bd-8abb-56c599e72929@xs4all.nl>
Date: Mon, 3 Dec 2018 09:29:14 +0100
MIME-Version: 1.0
In-Reply-To: <927806392.2404.1543824141142.JavaMail.zimbra@mycable.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2018 09:02 AM, Sebastian Süsens wrote:
> Hello,
> 
> I don't know how to get access to the v4l controls on a I2C camera sensor.
> 
> My driver structure looks following:
> 
> bridge driver                            -> csi-driver                                  -> sensor driver (includes controls)
> register-async-notifer for csi driver        register-async-notifer for sensor driver
> register video device
> 
> The v4l2 API say:
> When a sub-device is registered with a V4L2 driver by calling v4l2_device_register_subdev() and the ctrl_handler fields of both v4l2_subdev and v4l2_device are set, then the controls of the subdev will become automatically available in the V4L2 driver as well. If the subdev driver contains controls that already exist in the V4L2 driver, then those will be skipped (so a V4L2 driver can always override a subdev control).
> 
> But how can I get access to the controls by asynchronous registration, because the controls are not added to the video device automatically?

Yes, they are via v4l2_device_register_subdev(), which is called by the async code
when the subdev driver arrives.

Note that this assumes that the bridge driver has a control handler that struct
v4l2_device points to (the ctrl_handler field).

Also note that certain types of drivers (media controller-based) such as the imx
driver do not 'inherit' controls since each subdev has its own v4l-subdevX device node
through which its controls can be set. You do not mention which bridge driver you are
using, so I can't tell whether or not it falls in this category.

Regards,

	Hans

> 
> Normally I can use:
> 
> v4l2-ctl -l -d /dev/video0
> 
> I don't know if this forum is the right place for this question, so please answer with a private e-mail su@mycable.de
> 
> ------------------------------------------------------------------------
>    Sebastian Süsens               Tel.   +49 4321 559 56-27
>    mycable GmbH                   Fax    +49 4321 559 56-10
>    Gartenstrasse 10
>    24534 Neumuenster, Germany     Email  su@mycable.de
> ------------------------------------------------------------------------
>    mycable GmbH, Managing Director: Michael Carstens-Behrens
>    USt-IdNr: DE 214 231 199, Amtsgericht Kiel, HRB 1797 NM
> ------------------------------------------------------------------------
>    This e-mail and any files transmitted with it are confidential and
>    intended solely for the use of the individual or entity to whom
>    they are addressed. If you have received this e-mail in error,
>    please notify the sender and delete all copies from your system.
> ------------------------------------------------------------------------
> 
