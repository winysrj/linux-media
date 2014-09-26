Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37854 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbaIZKOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 06:14:17 -0400
Date: Fri, 26 Sep 2014 07:14:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926071411.61a011bd@recife.lan>
In-Reply-To: <20140926080824.GA8382@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
	<54241C81.60301@osg.samsung.com>
	<20140925160134.GA6207@linuxtv.org>
	<5424539D.8090503@osg.samsung.com>
	<20140925181747.GA21522@linuxtv.org>
	<542462C4.7020907@osg.samsung.com>
	<20140926080030.GB31491@linuxtv.org>
	<20140926080824.GA8382@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes/Shuah,

Em Fri, 26 Sep 2014 10:08:24 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 10:00:30AM +0200, Johannes Stezenbach wrote:
> > On Thu, Sep 25, 2014 at 12:45:24PM -0600, Shuah Khan wrote:
> > > 
> > > Revert is good. Just checked 3.16 and we are good
> > > on that. It needs to be reverted from 3.17 for sure.
> > > 
> > > ok now I know why the second path didn't
> > > apply. It depends on another change that added resume
> > > function
> > > 
> > > 7ab1c07614b984778a808dc22f84b682fedefea1
> > > 
> > > You don't need the second patch. The first patch applied
> > > to 3.17 and fails on 3.16
> > > 
> > > http://patchwork.linuxtv.org/patch/26073/
> > 
> > I'm not sure I understand correctly.  I applied the
> > b89193e0b06f revert plus the 26073 patchwork patch
> > on top of yesterday's git master (v3.17-rc6-247-g005f800),
> > the xc5000 request_firmware issue still happens, additionally
> > a drxk_attach request_firmware warning is printed after resume.

I just pushed the pending patched and added a reverted patch for
b89193e0b06f at the media_tree.git. Could you please use it to compile
or, if you prefer to keep using 3.16, you can use the media_build.git[1]
tree to just use the newest media stack on the top of 3.16.

[1] http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

I updated the today's tarball for it to have all the patches there.

> > I should mention I just test "boot -> hibernate -> resume",
> > the device is not opened before hibernate.
> 
> If I run dvb-fe-tool to load the xc5000 firmware before
> hibernate then the xc5000 issue seems fixed, but the
> drxk firmware issue still happens.

Please check if the xc5000 issue disappears with the current patches.

The drxk issue will likely need a similar fix to the one that Shuah
did to drxj.

Shuah,

Could you please take a look at the drx-k driver? It is not that different
from the drx-j.

Regards,
Mauro
