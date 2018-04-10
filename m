Return-path: <linux-media-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:60444 "EHLO mail.inka.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752458AbeDJTUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 15:20:16 -0400
Date: Tue, 10 Apr 2018 21:14:23 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-media@vger.kernel.org
Subject: Re: Confusion about API: please clarify
Message-ID: <20180410191423.GB28895@raven.inka.de>
References: <20180410104327.GA28895@raven.inka.de>
 <20180410115815.51ac801b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410115815.51ac801b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Di, Apr 10, 2018 at 11:58:15 -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Apr 2018 12:43:27 +0200
> Josef Wolf <jw@raven.inka.de> escreveu:
> > 
> > The linuxtv wiki pages state that the current v5 API (also called S2API) is
> > tag/value based:
> > 
> >   https://www.linuxtv.org/wiki/index.php/Development:_Linux_DVB_API_history_and_future
> >   https://www.linuxtv.org/wiki/index.php/S2API
> > 
> > But in the API documentation (version 5.10), I can't find anything that looks
> > like tag/value.
> 
> That refers basically to DVB frontend API. Please see:
> 	https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/dvbproperty.html

Thanks for the clarification, Mauro!

So all the other "subsystems" (like demux device etc/pp) still use the struct
based API?

What about DiSEqC? struct dvb_diseqc_master_cmd seems to still be limited to 6
bytes. With Unicable/JESS longer sequences are needed. Especially for configuring
multiswitches, sequences of up to 16 bytes are needed. How would this be done
with the limitation to 6 bytes?

Thanks,

-- 
Josef Wolf
jw@raven.inka.de
