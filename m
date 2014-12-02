Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:35765 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaLBWnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 17:43:05 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/3] Deprecate drivers
Date: Tue, 2 Dec 2014 23:42:18 +0100
Cc: linux-media@vger.kernel.org
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412022342.19472.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 December 2014 16:40:30 Hans Verkuil wrote:
> This patch series deprecates the vino/saa7191 video driver (ancient SGI
> Indy computer), the parallel port webcams bw-qcam, c-qcam and w9966, the
> ISA video capture driver pms and the USB video capture tlg2300 driver.
>
> Hardware for these devices is next to impossible to obtain, these drivers
> haven't seen any development in ages, they often use deprecated APIs and
> without hardware that's very difficult to port. And cheap alternative
> products are easily available today.

Just bought a QuickCam Pro parallel and some unknown parallel port webcam.
Will you accept patches? :)

> So move these drivers to staging for 3.19 and plan on removing them in
> 3.20.
>
> Regards,
>
> 	Hans

-- 
Ondrej Zary
