Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49603 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbaJ3NPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:15:33 -0400
Received: by mail-qg0-f42.google.com with SMTP id i50so3007341qgf.1
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 06:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904.1414668341.git.mchehab@osg.samsung.com>
References: <cover.1414668341.git.mchehab@osg.samsung.com>
	<678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904.1414668341.git.mchehab@osg.samsung.com>
Date: Thu, 30 Oct 2014 09:15:31 -0400
Message-ID: <CAGoCfizkcdU1fgfLjFHwnH34HgpJBcznO+3RrqOMHpLUYKCNPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media] sound: Update au0828 quirks table
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>,
	Daniel Mack <zonque@gmail.com>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>, alsa-devel@alsa-project.org,
	stable@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> Syncronize it and put them on the same order as found at au0828
> driver, as all the au0828 devices with analog TV need the
> same quirks.

The MXL and Woodbury boards don't support analog under Linux, so
probably shouldn't be included in the list of quirks.

That said, the MXL and Woodbury versions of the PCBs were prototypes
that never made it into production (and since the Auvitek chips are
EOL, they never will).  I wouldn't object to a patch which removed the
board profiles entirely in the interest of removing dead code.

It was certainly nice of Mike Krufky to work to get support into the
open source driver before the product was released, but after four
years it probably makes sense to remove the entries for products that
never actually shipped.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
