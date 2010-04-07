Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:36511 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0DGGKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 02:10:12 -0400
Received: by gxk9 with SMTP id 9so496325gxk.8
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 23:10:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Apr 2010 14:10:09 +0800
Message-ID: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>
Subject: Help needed in understanding v4l2_device_call_all
From: Bee Hock Goh <beehock@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to understand how the subdev function are triggered when I
use v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner,t) on
tm600-video.

How am i able to link the callback from the tuner_xc2028 function?

Please help me to understand or directly me to any documentation that
I can read up?

thanks,
 Hock.
