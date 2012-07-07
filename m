Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm13-vm0.bullet.mail.ird.yahoo.com ([77.238.189.195]:25837 "HELO
	nm13-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751666Ab2GGKrK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:47:10 -0400
Message-ID: <1341658028.44303.YahooMailClassic@web29405.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 11:47:08 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: unload/unplugging (Re: success! (Re: media_build and Terratec Cinergy T Black.))
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <4FF80EEA.2050606@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 7/7/12, Antti Palosaari <crope@iki.fi> wrote:

<snipped>
> > I am thinking either w_scan is doing something it
> should not, in which case we should inform its author to
> have this looked at, or the message does not need to be
> there?
> 
> As scandvb and all the other applications are able to set
> desired 
> parameters without that error it must be w_scan issue.

But scandvb does not work at all in my case (or rather, the bundled tuning files were wrong/out-dated).

> And personally I don't care whole warning, returning some
> error code 
> (which is likely -EINVAL) should be enough. It is not error
> situation in 
> the mean of Kernel or device error - it is just user error
> as user tries 
> to set unsupported frequency.

It is possibly just too much information in klog/dmesg .

> >>> The kernel seems happy while having the device
> >> physically pulled out. But the kernel module does
> not like
> >> to be unloaded (modprobe -r) while mplayer is
> running, so we
> >> need to fix that.
> >>
> >> Yep, seems to refuse unload. I suspect it is
> refused since
> >> there is ongoing USB transmission as it streams
> video. But
> >> should we allow that? And is removing open device
> nodes OK
> >> as applications holds those?
> >
> > I am thinking about suspend/resume, the poorman's way,
> which is to unload/reload. One interesting thing to try
> would be to pause but not quit the application - either just
> press pause, or say, 'gdb <mplayerbinary>
> <pid>', and see if 'modprobe -r' can be made to work
> under that sort of condition, if it isn't already.
> 
> hmm, what is that kind of suspend/resume?
> Is that different what is now implemented?

In the good old days, for drivers which does not suspend/hibernate well, one can add a file /etc/pm/config.d/myfile containing SUSPEND_MODULES="modname" to get them unloaded on suspend. Does it work with mplayer/vlc running or pausing?




