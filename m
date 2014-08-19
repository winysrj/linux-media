Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55226 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaHSQ3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 12:29:30 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so5397476oac.3
        for <linux-media@vger.kernel.org>; Tue, 19 Aug 2014 09:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1535351.AjE5s3odp7@avalon>
References: <20140813101411.15ca3a00.m.chehab@samsung.com> <1876821.kasfsvqvRP@avalon>
 <CAPybu_1KuYp7zc2024aaZHb_HYv4iZwBn2A5i6Y_uAVCK=fHVg@mail.gmail.com> <1535351.AjE5s3odp7@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 19 Aug 2014 18:29:08 +0200
Message-ID: <CAPybu_02Mksi53EwsNwebGPcEhGf+TDYcyD=nry1tN1Dz7OTqA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5Bmedia=2Dworkshop=5D_=5BANNOUNCE=5D_Linux_Kernel_Media_m?=
	=?UTF-8?Q?ini=2Dsummit_on_Oct=2C_16=2D17_in_D=C3=BCsseldorf=2C_Germany?=
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	dev@lists.tizen.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	gstreamer-announce@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent

> Could you elaborate a bit on that last point ? What kind of timestamps would
> you need, and what are the use cases ?

Right now we only have one timestamp field on the buffer structure, it
might be a good idea to leave space for some more.

My user case is a camera that is recording a conveyor belt at a very
high frame rate. Instead of tracking the objects on the image with I
use one or more encoders on the belt.  The encoder count  is read on
vsync and kept it on a register(s). When an image is ready, the cpu
starts the dma and read this "belt timestamps" registers.

It would be nice to have an standard way to expose this alternative
timestamps or at least find out if I am the only one with this issue
and/or how you have solve it :)


Best regards!


-- 
Ricardo Ribalda
