Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63629 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaKSIrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 03:47:03 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so183034wgh.18
        for <linux-media@vger.kernel.org>; Wed, 19 Nov 2014 00:47:02 -0800 (PST)
Date: Wed, 19 Nov 2014 09:46:56 +0100
From: Francesco Marletta <fmarletta@movia.biz>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Help required for TVP5151 on Overo
Message-ID: <20141119094656.5459258b@crow>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello to everyone,
I'd like to know who have used the TVP5151 video decoder with the OMAP3
Overo module.

I'm trying to have the processor to capture the video from a TVP5151
boarda, but without success (both gstreamer and yavta wait forever the
data from the V4L2 subsystem).

Thanks in advance!
