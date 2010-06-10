Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:54783 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab0FJHwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 03:52:14 -0400
Date: Thu, 10 Jun 2010 09:53:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: jiajun <zhujiajun@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: V4L Camera frame timestamp question
Message-ID: <20100610095338.35d46e1c@tele>
In-Reply-To: <loom.20100610T052202-829@post.gmane.org>
References: <loom.20100610T052202-829@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 10 Jun 2010 03:24:05 +0000 (UTC)
jiajun <zhujiajun@gmail.com> wrote:

> I'm currently using the V4L-DVB driver to control a few logitech
> webcams and playstation eye cameras on a Gubuntu system.
> 
> Everything works just fine except one thing:  the buffer timestamp
> value seems wrong.
	[snip]
> this should be the timestamp of when the image is taken (similar to
> gettimeofday() function)
> but the value I got is something way smaller (e.g. 75000) than what
> it should be (e.g. 1275931384)
> 
> Is this a known problem?

Hi,

No, I did not know it! Thank you. I will try to fix it for the kernel
2.6.35.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
