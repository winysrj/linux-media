Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4655 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1EEGYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 02:24:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Patches still pending at linux-media queue (18 patches)
Date: Thu, 5 May 2011 08:24:36 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?utf-8?q?Hern=C3=A1n_Ordiales?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Igor M. Liplianin" <liplianin@me.by>
References: <4DC2207B.5030700@redhat.com>
In-Reply-To: <4DC2207B.5030700@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105050824.36310.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, May 05, 2011 05:58:51 Mauro Carvalho Chehab wrote:
> I did a big effort those days to cleanup the patchwork queue. I'm still finishing to
> handle the git pull requests.
> 
> As several noticed, we had a very bad time with patchwork on the last weeks, due to
> some troubles at patchwork.kernel.org. That included:
> 	- Patches that disappeared from patchwork;
> 	- Patches that lost email body/SOB/From/Ack/Nack fields;
> 	- Patches sent that weren't caught by patchwork;
> 	- Patchwork lack of availability;
> 	- sync troubles between the mysql instances used by patchwork.
> 
> I've made a hard effort to recover those patches, and also did the kernel.org maintainer.
> John, thank you for your help.
> 
> I also did an effort to cleanup most of the old stuff from patchwork. On several cases,
> the patch were already applied, or another approach was taken. I also fixed manually some
> trivial troubles I've detected.
> 
> There are still 18 patches pending for merge, as described bellow.
> 
> 		== New patches == 
> 
> Those require more tests and/or reviews to be applied, as they are new. There are two patches
> related to UVC, 2 patches related to stv0899, 2 patches for cx18 and one VB1 patch. The last
> one requires more care, as videobuf is used on lots of drivers, So, tests for it are welcome.
> 
> Apr,29 2011: [1/2] V4L/DVB: v4l2-dev: revert commit c29fcff3daafbf46d64a543c1950bbd http://patchwork.kernel.org/patch/740691  Bob Liu <lliubbo@gmail.com>
> Apr,29 2011: [2/2] media:uvc_driver: Add support for NOMMU arch                     http://patchwork.kernel.org/patch/740671  Bob Liu <lliubbo@gmail.com>
> May, 4 2011: stb0899: Fix not locking DVB-S transponder                             http://patchwork.kernel.org/patch/753382  Lutz Sammer <johns98@gmx.net>
> May, 4 2011: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder               http://patchwork.kernel.org/patch/753392  Lutz Sammer <johns98@gmx.net>
> May, 3 2011: cx18: Clean up mmap() support for raw YUV                              http://patchwork.kernel.org/patch/749832  Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> May, 4 2011: cx18: Bump driver version to 1.5.0                                     http://patchwork.kernel.org/patch/753402  Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> Apr,19 2011: videobuf_pages_to_sg: sglist[0] length problem                         http://patchwork.kernel.org/patch/718421  Newson Edouard <newsondev@gmail.com>
> 
> 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
> 
> Manu,
> 	Can you please review those two patches?
> 
> Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
> Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>
> 
> 		== Waiting for Steven Stoth <stoth@kernellabs.com> review == 
> 
> Steven,
> 	This patch is here for a long time. Could you please check what's the status of it?
> 
> Nov,24 2010: [media] saa7164: poll mask set incorrectly                             http://patchwork.kernel.org/patch/351711  Dan Carpenter <error27@gmail.com>
> 
> 		== Waiting for Hans Verkuil <hansverk@cisco.com> review == 
> 
> Hans,
> 	I believe that want to replace this patch by something else, but better to keep it at the list while you don't
> send us a replacement.
> 
> Mar,26 2011: [media] cpia2: fix typo in variable initialisation                     http://patchwork.kernel.org/patch/665951  Mariusz Kozlowski <mk@lab.zgora.pl>

Feel free to merge this. It makes a broken driver slightly less broken.

I don't know when I will have time to create a proper patch that fixes this
driver. I need to get the work I'm doing on the control framework done first,
and that is taking a lot longer than I would like. But there is no sense in
keeping this patch back.

While working on the control framework I found a few bugs. I'll try to make
a pull request fixing them today or tomorrow at the latest.

Regards,

	Hans

> 
> 		== Waiting for Igor M. Liplianin <liplianin@me.by> review == 
> 
> Igor,
> 	Please check this patch. I'm not sure how to proceed with this one.
> 
> Oct,23 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/279091  Igor M. Liplianin <liplianin@me.by>
> 
> 		== Waiting for it to be applied upstream == 
> 
> I understood that this patch will follow via Tejun's tree. I'm keeping it here just
> for my own control. It will probably be removed after the next merge window.
> 
> Feb,15 2011: cx23885: restore flushes of cx23885_dev work items                     http://patchwork.kernel.org/patch/558301  Tejun Heo <tj@kernel.org>
> 
> 		== waiting for Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> submission == 
> 
> Sakari,
> 
> 	I'm understanding that you'll be handling this one.
> 
> Feb,19 2011: [RFC/PATCH,1/1] tcm825x: convert driver to V4L2 sub device interface   http://patchwork.kernel.org/patch/574931  David Cohen <dacohen@gmail.com>
> 
> 		== Waiting for Jonathan Corbet <corbet@lwn.net> ack == 
> 
> Jon,
> 	One patch for your ack ;)
> 
> Apr,29 2011: [media] via-camera: add MODULE_ALIAS                                   http://patchwork.kernel.org/patch/742581  Daniel Drake <dsd@laptop.org>
> 
> 		== waiting for Hernán Ordiales <h.ordiales@gmail.com> to provide a patch for S870 board == 
> 
> 
> The next 2 patches are waiting for a new review. I fixed some stuff there, but
> they're not ready yet for merge, requiring some care from the patch authors.
> 
> May, 3 2011: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/751702  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 		== waiting for updated version from Tomasz G. Burak tomekbu@op.pl == 
> 
> Feb, 7 2011: DVB-USB: Remote Control for TwinhanDTV StarBox DVB-S USB and clones    http://patchwork.kernel.org/patch/751832  Tomasz G. Burak <tomekbu@op.pl>
> 
> 		== Waiting for Mauro Carvalho Chehab <mchehab@redhat.com> fixes on Docbook == 
> 
> The last one is my fault: I need some time to work on this one ;) It is not urgent, as it just
> adds some automation to our DocBook. No functional changes and no documentation changes. So,
> it has very low priority, but if someone have some time, any help is welcome.
> 
> Oct,23 2010: [RFC, PATCHv3] DocBook: Add rules to auto-generate some media docbooks http://patchwork.kernel.org/patch/279201  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> Number of pending patches per reviewer:
>   LinuxTV community                                                     : 9
>   Manu Abraham <abraham.manu@gmail.com>                                 : 2
>   tomekbu@op.pl                                                         : 1
>   Steven Stoth <stoth@kernellabs.com>                                   : 1
>   Jonathan Corbet <corbet@lwn.net>                                      : 1
>   Mauro Carvalho Chehab <mchehab@redhat.com>                            : 1
>   Hans Verkuil <hansverk@cisco.com>                                     : 1
>   Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>                : 1
>   Igor M. Liplianin <liplianin@me.by>                                   : 1
> 
> Cheers,
> Mauro
> 
> ---
> 
> PS.: If you discover any patch submitted via email that weren't caught by
>      kernel.patchwork.org, please re-send and let me know. It may be due
>      to the problems that we had with patchwork over the last weeks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
