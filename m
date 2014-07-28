Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39637 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaG1QZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 12:25:01 -0400
Received: by mail-oa0-f50.google.com with SMTP id g18so8951868oah.37
        for <linux-media@vger.kernel.org>; Mon, 28 Jul 2014 09:25:00 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 28 Jul 2014 18:24:45 +0200
Message-ID: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
Subject: i.MX6 status for IPU/VPU/GPU
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, slongerbeam@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there !

We have a custom board, based on i.MX6 SoC.
We are currently using Freescale's release of Linux, but this is a
3.10.17 kernel, and several drivers are lacking (adv7611 for instance)
or badly written (all the MXC part).
As we want to have nice things :) we would like to use a mainline
kernel, or at least a tree which can be mainlined.

It seems (#v4l told me so) that some people (Steeve :) ?) are working
on a rewriting of the IPU and all DRM part for i.MX6.
What is the current status (compared to Freescale's release maybe) ?
And what can we expect in a near future ? Maybe, how can we help too ?

Thanks,
JM
