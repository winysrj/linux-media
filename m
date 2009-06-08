Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57588 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZFHBBu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 21:01:50 -0400
Subject: Re: funny colors from XC5000 on big endian systems
From: Andy Walls <awalls@radix.net>
To: "W. Michael Petullo" <mike@flyn.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
References: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 21:03:37 -0400
Message-Id: <1244423017.3144.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-07 at 20:22 -0400, W. Michael Petullo wrote:
> Is it possible that the XC5000 driver does not work properly on big endian
> systems? I am using Linux/PowerPC 2.6.29.4. I have tried to view an analog
> NTSC video stream from a Hauppauge 950Q using various applications
> (including GStreamer v4lsrc and XawTV). The video is always present, but
> in purple and green hues.

Sounds more like a problem with the analog video decoder/digitizer than
the tuner. 

Regards,
Andy

> Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

