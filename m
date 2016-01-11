Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33521 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192AbcAKUWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 15:22:53 -0500
Received: by mail-qk0-f170.google.com with SMTP id p186so150857335qke.0
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 12:22:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1601091126170.15612@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange> <Pine.LNX.4.64.1601091126170.15612@axis700.grange>
From: Daniel Johnson <teknotus@gmail.com>
Date: Mon, 11 Jan 2016 12:22:33 -0800
Message-ID: <CA+nDE0hdhrFfeVU_OsO847ehMdLtj7bjbC6E4an0s963jjXKTg@mail.gmail.com>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 9, 2016 at 2:27 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Mauro,
>
> Ping - what about this patch? If there are no comments - would you like me
> to push it via my tree?

In testing the V4L2_PIX_FMT_Z16 ('Z16 ') format documentation seems to
be incomplete.

uvc_xu_control_query unit=2 selector=4 seems to be a z scale factor.
Changing the value of that control greatly changes the value of
pixels. Millimeters seems to be correct for the default value of that
control. This control is on the /dev node for the infrared camera
rather than the node using the Z16 depth format.

The one thing that every depth camera I've ever used has in common is
factory calibration. Translating pixel values to Z is only 1/3 of what
is needed to translate a depth image into a point cloud. The
calibration is needed to translate X and Y pixel indexes into
positions in 3d space. Documentation on fetching, and parsing the
factory calibration would make the camera much more usable.

Documentation on the 21 UVC controls would be helpful, but less
critical than the calibration data.
