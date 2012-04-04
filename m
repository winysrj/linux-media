Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47703 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2DDXu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2012 19:50:57 -0400
Received: by wibhr17 with SMTP id hr17so917515wib.1
        for <linux-media@vger.kernel.org>; Wed, 04 Apr 2012 16:50:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 00:50:55 +0100
Message-ID: <CAK2bqVJT-AvRS9NYhRbpiZRHEVpUHUMxmHTW9OaS1+TYbsaVog@mail.gmail.com>
Subject: UVC video output problem with 3.3.1 kernel
From: Chris Rankin <rankincj@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a UVC video device, which lsusb describes as:

046d:0992 Logitech, Inc. QuickCam Communicate Deluxe

With the 3.3.1 kernel, the bottom 3rd of the video window displayed by
guvcview is completely black. This happens whenever I select either
BGR3 or RGB3 as the video output format. However, YUYV, YU12 and YV12
all display fine.

Does anyone else see this, please?
Thanks,
Chris
