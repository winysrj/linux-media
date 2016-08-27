Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60947 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932105AbcH0Nsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Aug 2016 09:48:36 -0400
Date: Sat, 27 Aug 2016 15:48:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: fcam-dev support for new kernels -- Re: [RFC PATCH 00/24] Make Nokia
 N900 cameras working
Message-ID: <20160827134832.GA5187@localhost>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!


> 
> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://

I modified fcam-dev to work with new kernel interface. It can now display
picture preview using SDL, and has somehow working autogain and autofocus.
It even includes very simple gui for manual focus and manual gain/exposure.

gitlab.com fcam-dev branch good.

Due to missing timestamping support, everything is quite slow. Auto white
balance does not work. 5 Mpix mode does not work (probably kernel problem),
and I do have hack in my kernel so that capture interface works.

Best regards,

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
