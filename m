Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42564 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZERItQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 04:49:16 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Mon, 18 May 2009 10:53:13 +0200
Cc: linux-media@vger.kernel.org
References: <loom.20090515T125828-924@post.gmane.org> <loom.20090518T065037-781@post.gmane.org> <loom.20090518T072801-624@post.gmane.org>
In-Reply-To: <loom.20090518T072801-624@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181053.14043.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guillaume,

On Monday 18 May 2009 09:32:53 Guillaume wrote:
> Guillaume <Kowaio <at> gmail.com> writes:
>
>
> I just tried the ENUM_FMT, and there is only 1 format, the JPEG one.
>
> But I don't understand one thing. The webcam displays compressed Jpeg data.
> OK.
> But before that compression, the data aren't in uncompressed data ?
> It's the driver or something which is doing that compression directly during
> the capture, but there really are no chance to get that uncompressed data
> before compression in JPEG ?

The video stream is compressed directly by the webcam and sent to the host in 
compressed form.

Best regards,

Laurent Pinchart

