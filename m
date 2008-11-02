Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0c317467cf5bb4e87def+1897+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KwUaI-0008Bt-0P
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 05:29:06 +0100
Date: Sun, 2 Nov 2008 02:27:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081102022728.68e5e564@pedra.chehab.org>
In-Reply-To: <200811011459.17706.hverkuil@xs4all.nl>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
Mime-Version: 1.0
Cc: Vitaly Wool <vwool@ru.mvista.com>,
	Dan Kreiser <kreiser@informatik.hu-berlin.de>,
	Lukas Kuna <lukas.kuna@evkanet.net>,
	Andre Kelmanson <akelmanson@gmail.com>, acano@fastmail.fm,
	John Stowers <john.stowers.lists@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
	Zhenyu Wang <zhen78@gmail.com>,
	v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	em28xx <em28xx@mcentral.de>, greg@kroah.com,
	Stefan Vonolfen <stefan.vonolfen@gmail.com>,
	Stephan Berberig <s.berberig@arcor.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Frank Neuber <fn@kernelport.de>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, 1 Nov 2008 14:59:17 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Markus,
> 
> As promised I've done a review of your empia driver and looked at what 
> needs to be done to get it into the kernel.
> 
> First of all, I've no doubt that your empia driver is better and 
> supports more devices than the current em28xx driver. I also have no 
> problem adding your driver separate from the current driver. It's been 
> done before (certain networking drivers spring to mind) and while 
> obviously not ideal I expect that the older em28xx driver can probably 
> be removed after a year or something like that.
> 
> In my opinion it's pretty much hopeless trying to convert the current 
> em28xx driver into what you have. It's a huge amount of work that no 
> one wants to do and (in this case) with very little benefit. Of course, 
> Mauro has the final say in this.
> 

Both upstream and the 4 duplicated drivers have similar functionality. Also,
the upstream driver is actively maintained. So, there's no sense on accepting
those duplicated drivers.

Also, just replacing one existing driver by a newer one will cause regressions
on some already fixed bugs and remove some improvements that the upstream driver
suffered.

If there's a bug or a lack of functionality on em28xx, cx25843, xc5000 or
tuner-xc2028, it is just a matter of submitting patches fixing those bugs or
adding newer features.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
