Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37653 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab0FQOoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 10:44:08 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 17 Jun 2010 09:44:03 -0500
Subject: RE: sub device device node and ioctl support?
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B3A7873@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4016B3A7671@dlee06.ent.ti.com>
 <201006170903.12665.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201006170903.12665.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Laurent,

>
>The media controller upstreaming process will start in one or two weeks.
>This
>will require a lot of time, so everything won't be ready for 2.6.36.
>
>This being said, the subdevice userspace API is the first part of the media
>controller that will be pushed upstream.

Is this already being reviewed in the list? If not, I suggest you send it
for review separately, not with the media controller patch set.

 Getting it ready for 2.6.36 might
>be
>a bit difficult, it will depend on how many rc cycles we still get for
>2.6.35.
>It will also depend on how fast the patches get reviewed, so you can help
>there :-)
>

Of course I will review this since I need it for my work. If you can make it
against the v4l-dvb latest tree, I can apply and get it tested since we
are working on to add osd sub device for DMxxx VPBE display driver. 

>--
>Regards,
>
>Laurent Pinchart
