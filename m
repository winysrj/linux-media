Return-path: <linux-media-owner@vger.kernel.org>
Received: from belief.htu.tuwien.ac.at ([128.131.95.14]:34881 "EHLO
	belief.htu.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3GQVbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 17:31:41 -0400
Date: Wed, 17 Jul 2013 23:31:39 +0200
From: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130717213139.GA14370@deadlock.dhs.org>
References: <20130716220418.GC10973@deadlock.dhs.org> <20130717084428.GA2334@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717084428.GA2334@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Wed, Jul 17, 2013 at 05:44:29AM -0300, Ezequiel Garcia wrote:
> On Wed, Jul 17, 2013 at 12:04:18AM +0200, Sergey 'Jin' Bostandzhyan wrote:
> > 
> > It generally works fine, I can, for example, open the video device using VLC,
> > select one of the inputs and get the picture.
> > 
> > However, programs like motion or zoneminder fail, I am not quite sure if it
> > is something that they might be doing or if it is a problem in the driver.
> > 
> > Basically, for both of the above, the problem is that VIDIOC_S_INPUT fails
> > with EBUSY.
> > 
> 
> I've just sent a patch to fix this issue.
> 
> Could you try it and let me know if it solves your issue?

thanks a lot! Just tried it, same fix is needed for vidioc_s_std(), then
the errors in motion and zoneminder are gone!

Motion seems to work now, with zoneminder I get a lot of these messages:
Jul 17 23:28:27 localhost kernel: [20641.931990] stk1160_copy_video: 5563 callbacks suppressed
Jul 17 23:28:27 localhost kernel: [20641.931998] stk1160: buffer overflow detected
Jul 17 23:28:27 localhost kernel: [20641.932000] stk1160: buffer overflow detected

Anything to worry about?

The image is also garbled in zoneminder, but since it works fine in motion I
would assume that this is not a driver problem anymore, probably some bug in
the zoneminder application.

Thanks a lot for the quick fix!

Kind regards,
Sergey

