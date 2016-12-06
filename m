Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47717
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751244AbcLFAii (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 19:38:38 -0500
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share media
 resources
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1480539942.git.shuahkh@osg.samsung.com>
 <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com>
 <69ad05a8-8572-43e7-ef76-7510edd904c6@osg.samsung.com>
 <2368883.8y0L28vD2m@avalon>
Cc: mchehab@kernel.org, tiwai@suse.com, perex@perex.cz,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        sakari.ailus@iki.fi, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <d0a8e556-915c-4f14-d45e-a36a11fb5c6d@osg.samsung.com>
Date: Mon, 5 Dec 2016 17:38:23 -0700
MIME-Version: 1.0
In-Reply-To: <2368883.8y0L28vD2m@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2016 04:21 PM, Laurent Pinchart wrote:
> Hi Shuah,
> 
> On Monday 05 Dec 2016 15:44:30 Shuah Khan wrote:
>> On 11/30/2016 03:01 PM, Shuah Khan wrote:
>>> Change ALSA driver to use Media Controller API to share media resources
>>> with DVB, and V4L2 drivers on a AU0828 media device.
>>>
>>> Media Controller specific initialization is done after sound card is
>>> registered. ALSA creates Media interface and entity function graph
>>> nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
>>>
>>> snd_usb_hw_params() will call Media Controller enable source handler
>>> interface to request the media resource. If resource request is granted,
>>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>>> returned.
>>>
>>> Media specific cleanup is done in usb_audio_disconnect().
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>
>> Hi Takashi,
>>
>> If you are good with this patch, could you please Ack it, so Mauro
>> can pull it into media tree with the other two patches in this series,
>> when he is ready to do so.
> 
> I *really* want to address the concerns raised by Sakari before pulling more 
> code that makes fixing the race conditions more difficult. Please, let's all 
> work on fixing the core code to build a stable base on which we can build 
> additional features. V4L2 and MC need teamwork, it's time to give the 
> subsystem the love it deserves.
> 

Hi Laurent,

The issue Sakari brought up is specific to using devm for video_device in
omap3 and vsp1. I tried reproducing the problem on two different drivers
and couldn't on Linux 4.9-rc7.

After sharing that with Sakari, I suggested to Sakari to pull up his patch
that removes the devm usage and see if he still needs all the patches in his
patch series. He didn't back to me on that. I also requested him to rebase on
top of media dev allocator because the allocator routines he has don't address
the shared media device need.

He also didn't respond to my response regarding the reasons for choosing
graph_mutex to protect enable_source and disable_source handlers.

So I am not sure how to move forward at the moment without a concrete plan
for Sakari's RFC series. Sakari's patch series is still RFC and doesn't address
shared media_device and requires all drivers to change.

thanks,
-- Shuah
