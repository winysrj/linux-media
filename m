Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32986 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0JSV6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 17:58:49 -0400
Received: by eyx24 with SMTP id 24so358134eyx.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 14:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin4w=0sheXsfsPve7ivjrdUO-+9mHCCbwCkW=cP@mail.gmail.com>
References: <AANLkTin4w=0sheXsfsPve7ivjrdUO-+9mHCCbwCkW=cP@mail.gmail.com>
Date: Tue, 19 Oct 2010 14:58:48 -0700
Message-ID: <AANLkTinw9xUPRv=gXM6KtnXEdtdMbz_TJKKV+ojm6+C0@mail.gmail.com>
Subject: soc_camera device
From: Hal Moroff <halm90@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm pretty new to Linux video drivers (I do have experience with
drivers in general) and am trying to get my head
around the driver models.  Sorry if this is too basic a question for this forum.

I have an OMAP 3530 running Arago Linux (2.6.32 at the moment), and
I'm trying to capture images from an Aptina
sensor for which there does not seem to be a driver.

There seem to be soc_camera, soc_camera-int, v4l2, omap34xxcam drivers
at the very least.  I'm pretty confused
over these and how they do or don't work with V4L2 and/or each other.

It seems that some of the driver models are deprecated (but still in
use), and that soc_camera is current.  Or is it?

2 things in particular at the moment are giving me a hard time:
  1. I can't seem to load soc_camera.ko ... I keep getting the error:
      soc_camera: exports duplicate symbol soc_camera_host_unregister
(owned by kernel)
      I can't seem to resolve this, nor can I find the issue described
in any online forum (and so
      I suspect it's my problem).

  2. There are drivers for the Aptina MT9V022 and the MT9M001 (among
others).  Both of these
      are sensors, and not SOC, and yet both of these rely on the
soc_camera module.  I'm willing
      to create the driver for my Aptina sensor, and the easiest way
is generally to look at a known
      driver as a template, however I can't figure out which to look at.
