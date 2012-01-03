Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60887 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2ACBOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 20:14:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dilip Mannil <mannil.dilip@gmail.com>
Subject: Re: Multiple channel capture support in V4l2 layer
Date: Tue, 3 Jan 2012 02:14:21 +0100
Cc: linux-media@vger.kernel.org
References: <CAD6K1_OqO37F6omqDGHbn2D9pCBi9bmodQkmwNy_1WYyrksL6Q@mail.gmail.com>
In-Reply-To: <CAD6K1_OqO37F6omqDGHbn2D9pCBi9bmodQkmwNy_1WYyrksL6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201030214.22522.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dilip,

On Friday 23 December 2011 19:57:22 Dilip Mannil wrote:
> Hi,
> I am trying to implement v4l2 slave driver for  ML86V76654  digital
> video decoder that converts NTSC, PAL, SECAM analog video signals into
> the YCbCr standard digital format. This codec takes 4 analog inputs(2
> analog camera + 2 ext video in) and encodes in to digital(only one at
> a time).
> 
> The driver should be able to switch between capture channels upon
> request from user space application.
> 
> I couldn't find the support for multiple capture channels on a single
> device in v4l2 layer. Please correct me if I am wrong.
> 
> Ideally I want the v4l2 slave driver to have following feature.
> 
> 1. ioctl that can be used to enumerate/get/set the  capture channels
> on the video encoder.
> 2. Able to capture video from the currently set capture channel and
> pass to higher layers.
> 
> Which is the best way to implement this support?

VIDIOC_ENUMINPUT and VIDIOC_[GS]_INPUT seem to be what you're looking for.

-- 
Regards,

Laurent Pinchart
