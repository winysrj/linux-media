Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33753 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbcLEXUv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 18:20:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, tiwai@suse.com, perex@perex.cz,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        sakari.ailus@iki.fi, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share media resources
Date: Tue, 06 Dec 2016 01:21:11 +0200
Message-ID: <2368883.8y0L28vD2m@avalon>
In-Reply-To: <69ad05a8-8572-43e7-ef76-7510edd904c6@osg.samsung.com>
References: <cover.1480539942.git.shuahkh@osg.samsung.com> <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com> <69ad05a8-8572-43e7-ef76-7510edd904c6@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Monday 05 Dec 2016 15:44:30 Shuah Khan wrote:
> On 11/30/2016 03:01 PM, Shuah Khan wrote:
> > Change ALSA driver to use Media Controller API to share media resources
> > with DVB, and V4L2 drivers on a AU0828 media device.
> > 
> > Media Controller specific initialization is done after sound card is
> > registered. ALSA creates Media interface and entity function graph
> > nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
> > 
> > snd_usb_hw_params() will call Media Controller enable source handler
> > interface to request the media resource. If resource request is granted,
> > it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
> > returned.
> > 
> > Media specific cleanup is done in usb_audio_disconnect().
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> Hi Takashi,
> 
> If you are good with this patch, could you please Ack it, so Mauro
> can pull it into media tree with the other two patches in this series,
> when he is ready to do so.

I *really* want to address the concerns raised by Sakari before pulling more 
code that makes fixing the race conditions more difficult. Please, let's all 
work on fixing the core code to build a stable base on which we can build 
additional features. V4L2 and MC need teamwork, it's time to give the 
subsystem the love it deserves.

-- 
Regards,

Laurent Pinchart

