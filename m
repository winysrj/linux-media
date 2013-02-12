Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1869 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3BLIAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:00:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH 0/4] em28xx: add image quality bridge controls
Date: Tue, 12 Feb 2013 09:00:09 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1360604916-3048-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360604916-3048-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302120900.09610.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 18:48:32 Frank Schäfer wrote:
> The first two patches remove unused code.
> The third patch makes sure that the same image quality default settings are used
> everywhere in the code.
> The fourth patch finally adds the following image quality bridge controls:
> - contrast
> - brightness
> - saturation
> - blue balance
> - red balance
> - sharpness
> 
> Tested with the following devices:
> "Terratec Cinergy 200 USB"
> "Hauppauge HVR-900"
> "SilverCrest 1.3MPix webcam"
> "Hauppauge WinTV USB2"
> "Speedlink VAD Laplace webcam"
> 
> 
> Frank Schäfer (4):
>   em28xx: remove unused image quality control functions
>   em28xx: remove unused ac97 v4l2_ctrl_handler
>   em28xx: introduce #defines for the image quality default settings
>   em28xx: add image quality bridge controls
> 
>  drivers/media/usb/em28xx/em28xx-cards.c |    7 +---
>  drivers/media/usb/em28xx/em28xx-core.c  |   12 +++---
>  drivers/media/usb/em28xx/em28xx-reg.h   |   23 ++++++++---
>  drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++++++++++++-
>  drivers/media/usb/em28xx/em28xx.h       |   68 -------------------------------
>  5 Dateien geändert, 80 Zeilen hinzugefügt(+), 88 Zeilen entfernt(-)
> 
> 

Looks good:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
