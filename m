Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59468 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754615AbeBNMN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:13:56 -0500
Subject: Re: exposing a large-ish calibration table through V4L2?
To: Florian Echtler <floe@butterbrot.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>
Date: Wed, 14 Feb 2018 13:13:55 +0100
MIME-Version: 1.0
In-Reply-To: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 14/02/18 13:09, Florian Echtler wrote:
> Hello Hans,
> 
> I've picked up work on the sur40 driver again recently. There is one major
> feature left that is currently unsupported by the Linux driver, which is the
> hardware-based calibration.
> 
> The internal device memory contains a table with two bytes for each sensor pixel
> (i.e. 960x540x2 = 1036800 bytes) that basically provide individual black and
> white levels per-pixel that are used in preprocessing. The table can either be
> set externally, or the sensor can be covered with a black/white surface and a
> custom command triggers an internal calibration.
> 
> AFAICT the usual V4L2 controls are unsuitable for this sort of data; do you have
> any suggestions on how to approach this? Maybe something like a custom IOCTL?

So the table has a fixed size?

You can use array controls for that, a V4L2_CTRL_TYPE_U16 in a two-dimensional array
would do it.

See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-queryctrl.html for more
information on how this works.

Regards,

	Hans
