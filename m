Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:30446
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933832AbdBQN6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 08:58:00 -0500
From: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
Date: Fri, 17 Feb 2017 13:57:57 +0000
Message-ID: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual Channels. I =
want to configure each virtual channel individually (e.g. set_fmt), but the=
 v4l2 interface does not seem to have a clear way to access configuration o=
n a virtual channel level, but only the v4l2_subdev as a whole. Using one v=
4l2_subdev for multiple virtual channels by extending the "reg" tag to be a=
n array looks like the correct way to do it, based on the mipi-dsi-bus.txt =
document and current device tree endpoint structure.

However, I cannot figure out how to extend e.g. set_fmt/get_fmt subdev ioct=
ls to specify which virtual channel the call applies to. Does anyone have a=
ny advice on how to handle this case?

Previous thread: "Device Tree formatting for multiple virtual channels in t=
i-vpe/cal driver?"


Best Regards,
Thomas Axelsson

PS. First e-mail seems to have gotten caught in the spam filter. I apologiz=
e if this is a duplicate.
