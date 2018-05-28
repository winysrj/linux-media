Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38130 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034074AbeE1KZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:25:53 -0400
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org
References: <10831984.07PNLvckhh@avalon> <20180525201027.1d5c82eb@vento.lan>
 <4867226.Y05TeWaCcJ@avalon>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <723a9624-04aa-d311-c3cd-7858bca7a901@ideasonboard.com>
Date: Mon, 28 May 2018 11:25:48 +0100
MIME-Version: 1.0
In-Reply-To: <4867226.Y05TeWaCcJ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Laurent,

On 26/05/18 00:39, Laurent Pinchart wrote:
> Hi Mauro,
> 
> (CC'ing Kieran)
> 
> On Saturday, 26 May 2018 02:10:27 EEST Mauro Carvalho Chehab wrote:
>> Em Sun, 20 May 2018 15:10:50 +0300 Laurent Pinchart escreveu:
>>> Hi Mauro,
>>>
>>> The following changes since commit
>>> 8ed8bba70b4355b1ba029b151ade84475dd12991:
>>>   media: imx274: remove non-indexed pointers from mode_table (2018-05-17
>>> 06:22:08 -0400)
>>>
>>> are available in the Git repository at:
>>>   git://linuxtv.org/pinchartl/media.git v4l2/vsp1/next
>>>
>>> for you to fetch changes up to 429f256501652c90a4ed82f2416618f82a77d37c:
>>>   media: vsp1: Move video configuration to a cached dlb (2018-05-20
>>>   09:46:51 +0300)
>>>
>>> The branch passes the VSP and DU test suites, both on its own and when
>>> merged with the drm-next branch.
>>
>> This series added a new warning:
>>
>> drivers/media/platform/vsp1/vsp1_dl.c:69: warning: Function parameter or
>> member 'refcnt' not described in 'vsp1_dl_body'
> 
> We'll fix that. Kieran, as you authored the code, would you like to give it a 
> go ?

Sent!

Thanks for the catch.

--
Kieran



>> To the already existing one:
>>
>> drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx()
>> error: we previously assumed 'pipe->brx' could be null (see line 244)
> 
> That's still on my todo list. I tried to give it a go but received plenty of 
> SQL errors. How do you run smatch ?
> 
>> (there's also a Spectre warning too, but I'll looking into those
>> in separate).
>>
>> For now, I'll apply it, but I reserve the right of not pulling any
>> new patchsets that would add more warnings.
>>
>>> ----------------------------------------------------------------
>>>
>>> Geert Uytterhoeven (1):
>>>       media: vsp1: Drop OF dependency of VIDEO_RENESAS_VSP1
>>>
>>> Kieran Bingham (10):
>>>       media: vsp1: Release buffers for each video node
>>>       media: vsp1: Move video suspend resume handling to video object
>>>       media: vsp1: Reword uses of 'fragment' as 'body'
>>>       media: vsp1: Protect bodies against overflow
>>>       media: vsp1: Provide a body pool
>>>       media: vsp1: Convert display lists to use new body pool
>>>       media: vsp1: Use reference counting for bodies
>>>       media: vsp1: Refactor display list configure operations
>>>       media: vsp1: Adapt entities to configure into a body
>>>       media: vsp1: Move video configuration to a cached dlb
>>>  
>>>  drivers/media/platform/Kconfig            |   2 +-
>>>  drivers/media/platform/vsp1/vsp1_brx.c    |  32 ++--
>>>  drivers/media/platform/vsp1/vsp1_clu.c    | 113 ++++++-----
>>>  drivers/media/platform/vsp1/vsp1_clu.h    |   1 +
>>>  drivers/media/platform/vsp1/vsp1_dl.c     | 388 ++++++++++++++-----------
>>>  drivers/media/platform/vsp1/vsp1_dl.h     |  21 ++-
>>>  drivers/media/platform/vsp1/vsp1_drm.c    |  18 +-
>>>  drivers/media/platform/vsp1/vsp1_drv.c    |   4 +-
>>>  drivers/media/platform/vsp1/vsp1_entity.c |  34 +++-
>>>  drivers/media/platform/vsp1/vsp1_entity.h |  45 +++--
>>>  drivers/media/platform/vsp1/vsp1_hgo.c    |  26 ++-
>>>  drivers/media/platform/vsp1/vsp1_hgt.c    |  28 ++-
>>>  drivers/media/platform/vsp1/vsp1_hsit.c   |  20 +-
>>>  drivers/media/platform/vsp1/vsp1_lif.c    |  25 ++-
>>>  drivers/media/platform/vsp1/vsp1_lut.c    |  80 +++++---
>>>  drivers/media/platform/vsp1/vsp1_lut.h    |   1 +
>>>  drivers/media/platform/vsp1/vsp1_pipe.c   |  74 +-------
>>>  drivers/media/platform/vsp1/vsp1_pipe.h   |  12 +-
>>>  drivers/media/platform/vsp1/vsp1_rpf.c    | 189 ++++++++++---------
>>>  drivers/media/platform/vsp1/vsp1_sru.c    |  24 +--
>>>  drivers/media/platform/vsp1/vsp1_uds.c    |  73 +++----
>>>  drivers/media/platform/vsp1/vsp1_uds.h    |   2 +-
>>>  drivers/media/platform/vsp1/vsp1_uif.c    |  35 ++--
>>>  drivers/media/platform/vsp1/vsp1_video.c  | 177 ++++++++++++-----
>>>  drivers/media/platform/vsp1/vsp1_video.h  |   3 +
>>>  drivers/media/platform/vsp1/vsp1_wpf.c    | 326 ++++++++++++++-----------
>>>  26 files changed, 967 insertions(+), 786 deletions(-)
> 
