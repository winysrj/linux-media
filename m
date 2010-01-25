Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53152 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0AYSGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 13:06:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: git problem with uvcvideo
Date: Mon, 25 Jan 2010 19:07:18 +0100
Cc: V4L Mailing List <linux-media@vger.kernel.org>
References: <4B5CBC31.5090701@freemail.hu>
In-Reply-To: <4B5CBC31.5090701@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001251907.18266.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Márton,

On Sunday 24 January 2010 22:31:29 Németh Márton wrote:
> Hi,
> 
> I'm trying to fetch the uvcvideo from
>  http://linuxtv.org/git/?p=pinchartl/uvcvideo.git;a=summary .
> 
> I tryied to follow the instructions but at the third step I get fatal error
> messages:

[snip]

The http:// URL seems not to be available at the moment. I don't know if it's 
a transient error or a deliberate decision not to provide git access through 
http://

> I also tried with the git:// link:
> > v4l-dvb$ git remote rm uvcvideo
> > v4l-dvb$ git remote add uvcvideo git://linuxtv.org//pinchartl/uvcvideo.git
> > v4l-dvb$ git remote update
> > Updating origin
> > Updating uvcvideo
> > fatal: The remote end hung up unexpectedly
> > error: Could not fetch uvcvideo
> 
> Am I doing something wrong?

Please try git://linuxtv.org/pinchartl/uvcvideo.git. The URL on the webpage 
has two / instead of one for some reason. Mauro, could that be fixed ?

-- 
Regards,

Laurent Pinchart
