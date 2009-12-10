Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50758 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869AbZLJPoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 10:44:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pablo Baena <pbaena@gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
Date: Thu, 10 Dec 2009 16:46:26 +0100
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com> <200912101519.04700.laurent.pinchart@ideasonboard.com> <36be2c7a0912100726t65de68c6n2f02eea25ac5a586@mail.gmail.com>
In-Reply-To: <36be2c7a0912100726t65de68c6n2f02eea25ac5a586@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912101646.26333.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 December 2009 16:26:19 Pablo Baena wrote:
> Can you tell me how to obtain such backtrace? This is a hard panic and
> I don't know how to obtain a backtrace, since the keyboard gets
> unresponsive.

Once the kernel crashes in interrupt context there's not much you can do. One 
solution would be to write the backtrace down, but that's a bit tedious :-)

Another solution, if your computer has a serial port, is to activate a serial 
console and hook it up to another computer where you will be able to capture 
the oops.

-- 
Regards,

Laurent Pinchart
