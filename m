Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39598 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1J3VPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 17:15:23 -0400
Date: Sun, 30 Oct 2011 22:15:12 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Piotr Chmura <chmooreck@poczta.onet.pl>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>, LMML <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH 11/14] staging/media/as102: fix compile warning
 about unused function
Message-ID: <20111030221512.339dfe36@stein>
In-Reply-To: <4EADADE1.4080606@gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111336.62af07ce.chmooreck@poczta.onet.pl>
	<20111018220352.3179feb1@darkstar>
	<4EADADE1.4080606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 30 Sylwester Nawrocki wrote:
> On 10/18/2011 10:03 PM, Piotr Chmura wrote:
> > Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
[...]
> > +#if (LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19))
> 
> I was wondering, could such a conditional compilation be simply skipped when
> we are merging the driver into exactly known kernel version ?  
> For backports there are separate patches at media_build.git and I can't see
> such an approach used in any driver upstream.

Compatibility code is in fact not allowed anymore upstream.  But AFAIU,
this patch here does not have such a cleanup in its scope.  If the compat
removal isn't already included later on in Piotr's series, it will be done
later before this driver can be moved out of staging.
-- 
Stefan Richter
-=====-==-== =-=- ====-
http://arcgraph.de/sr/
