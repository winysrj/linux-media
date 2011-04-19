Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56956 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1DSMQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:16:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?Zden=C4=9Bk_Materna?= <zdenek.materna@gmail.com>
Subject: Re: Genius webcam problem on ARM
Date: Tue, 19 Apr 2011 14:16:15 +0200
Cc: linux-media@vger.kernel.org
References: <BANLkTink9O=Gd1o0ytnS2OUot=0tdCTP3g@mail.gmail.com> <BANLkTim0RgsZ5J5RAiGxVjTTEi8qGf4DCg@mail.gmail.com> <BANLkTinfxRNmXe69-sg57MdDVgHfcVsywQ@mail.gmail.com>
In-Reply-To: <BANLkTinfxRNmXe69-sg57MdDVgHfcVsywQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104191416.18274.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tuesday 12 April 2011 19:53:22 Zdeněk Materna wrote:
> Hello,
> 
> I'm sorry for another mail. It works with quirks 128 and uncompressed
> YUV format. Is there any way how to use compressed MJPEG? Should I try
> compile never uvcvideo driver?

Could you post the output of lsusb -v for your camera when plugged in to your 
ARM board ?

-- 
Regards,

Laurent Pinchart
