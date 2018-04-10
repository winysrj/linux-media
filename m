Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53937 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbeDJUWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 16:22:45 -0400
Date: Tue, 10 Apr 2018 17:22:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Josef Wolf <jw@raven.inka.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Confusion about API: please clarify
Message-ID: <20180410172239.647957ba@vento.lan>
In-Reply-To: <20180410191423.GB28895@raven.inka.de>
References: <20180410104327.GA28895@raven.inka.de>
        <20180410115815.51ac801b@vento.lan>
        <20180410191423.GB28895@raven.inka.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Apr 2018 21:14:23 +0200
Josef Wolf <jw@raven.inka.de> escreveu:

> On Di, Apr 10, 2018 at 11:58:15 -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 10 Apr 2018 12:43:27 +0200
> > Josef Wolf <jw@raven.inka.de> escreveu:  
> > > 
> > > The linuxtv wiki pages state that the current v5 API (also called S2API) is
> > > tag/value based:
> > > 
> > >   https://www.linuxtv.org/wiki/index.php/Development:_Linux_DVB_API_history_and_future
> > >   https://www.linuxtv.org/wiki/index.php/S2API
> > > 
> > > But in the API documentation (version 5.10), I can't find anything that looks
> > > like tag/value.  
> > 
> > That refers basically to DVB frontend API. Please see:
> > 	https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/dvbproperty.html  
> 
> Thanks for the clarification, Mauro!
> 
> So all the other "subsystems" (like demux device etc/pp) still use the struct
> based API?

Yes.

> What about DiSEqC? struct dvb_diseqc_master_cmd seems to still be limited to 6
> bytes. With Unicable/JESS longer sequences are needed. Especially for configuring
> multiswitches, sequences of up to 16 bytes are needed. How would this be done
> with the limitation to 6 bytes?

DiSEqC uses stuct-based ioctl. 

There is a provision to add support for it via S2API, but this was not
implemented yet.

That's said, adding suport for DiSEqC with more than 6 bytes should
likely be enabled driver per driver, after checking that the device
supports it.

For example, cx24123 seems to reserve only 6 registers for
messages (from cx24123.c driver, at cx24123_regdata[] table):

        {0x2c, 0x00}, /* DiSEqC Message (0x2c - 0x31) */

Register 0x33 is used for interrupts.
        {0x33, 0x00}, /* Interrupts off (0x33 - 0x34) */
        {0x34, 0x00},

So, clearly this device won't be able to support longer DiSEqC
messages.

Regards,
Mauro
