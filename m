Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36269 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbcBOLkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 06:40:14 -0500
MIME-Version: 1.0
In-Reply-To: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Date: Mon, 15 Feb 2016 12:40:12 +0100
Message-ID: <CAO3366zt+O0JTGjPm1QA4VtksycAgDeVf3VzK3rWBeWXVtYdzg@mail.gmail.com>
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
From: Ulrich Hecht <ulrich.hecht@gmail.com>
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 14, 2016 at 5:55 PM, Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> A V4L2 driver for Renesas R-Car VIN IP cores that do not depend on
> soc_camera. The driver is heavily based on its predecessor and aims to
> replace the soc_camera driver.

Thanks a lot, this will allow me to implement HDMI input properly.

One issue: With either HDMI or analog, I get a black picture using
MMIO, while using read() works.

> The driver is tested on Koelsch and can grab frames using yavta.  It
> also passes a v4l2-compliance (1.10.0) run without failures. There is
> however a issues sometimes if one first run v4l2-compliance and then
> yavta the grabbed frames are a bit fuzzy. I'm working on it.

For the record, I have had the same problem with the old driver, but I
was not able to reproduce it reliably.

CU
Uli
