Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41451
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752913AbcLIQlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 11:41:04 -0500
Subject: Re: [PATCH v6 3/3] sound/usb: Use Media Controller API to share media
 resources
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1480539942.git.shuahkh@osg.samsung.com>
 <ebeaa42019b102f76d87a2fc4aa7793e1f87072c.1480539942.git.shuahkh@osg.samsung.com>
 <69ad05a8-8572-43e7-ef76-7510edd904c6@osg.samsung.com>
 <2368883.8y0L28vD2m@avalon>
 <d0a8e556-915c-4f14-d45e-a36a11fb5c6d@osg.samsung.com>
 <20161207105207.GW16630@valkosipuli.retiisi.org.uk>
 <f83b60c1-9e1a-df5c-b1ec-de2ddd219307@osg.samsung.com>
 <20161207222738.GY16630@valkosipuli.retiisi.org.uk>
 <5566cc23-62c3-7a4a-073d-7c340a22e984@osg.samsung.com>
 <20161208234407.GK16630@valkosipuli.retiisi.org.uk>
 <20161209131756.GN16630@valkosipuli.retiisi.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, tiwai@suse.com, perex@perex.cz,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <64053e77-f16b-e0a3-2a8b-a21c3bc94bc4@osg.samsung.com>
Date: Fri, 9 Dec 2016 09:40:53 -0700
MIME-Version: 1.0
In-Reply-To: <20161209131756.GN16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2016 06:17 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Fri, Dec 09, 2016 at 01:44:07AM +0200, Sakari Ailus wrote:
>> Hi Shuah,
>>
>> On Thu, Dec 08, 2016 at 07:46:03AM -0700, Shuah Khan wrote:
>>> Hi Sakari,
>>>
>>> On 12/07/2016 03:27 PM, Sakari Ailus wrote:
>>>> Hi Shuah,
>>>>
>>>> On Wed, Dec 07, 2016 at 01:03:59PM -0700, Shuah Khan wrote:
>>>>> Hi Sakari,
>>>>>
>>>>> On 12/07/2016 03:52 AM, Sakari Ailus wrote:
>>>>>> Hi Shuah,
>>>>>>
>>>>>> On Mon, Dec 05, 2016 at 05:38:23PM -0700, Shuah Khan wrote:
>>>>>>> On 12/05/2016 04:21 PM, Laurent Pinchart wrote:
>>>>>>>> Hi Shuah,
>>>>>>>>
>>>>>>>> On Monday 05 Dec 2016 15:44:30 Shuah Khan wrote:
>>>>>>>>> On 11/30/2016 03:01 PM, Shuah Khan wrote:
>>>>>>>>>> Change ALSA driver to use Media Controller API to share media resources
>>>>>>>>>> with DVB, and V4L2 drivers on a AU0828 media device.
>>>>>>>>>>
>>>>>>>>>> Media Controller specific initialization is done after sound card is
>>>>>>>>>> registered. ALSA creates Media interface and entity function graph
>>>>>>>>>> nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
>>>>>>>>>>
>>>>>>>>>> snd_usb_hw_params() will call Media Controller enable source handler
>>>>>>>>>> interface to request the media resource. If resource request is granted,
>>>>>>>>>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>>>>>>>>>> returned.
>>>>>>>>>>
>>>>>>>>>> Media specific cleanup is done in usb_audio_disconnect().
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>>>>>>>
>>>>>>>>> Hi Takashi,
>>>>>>>>>
>>>>>>>>> If you are good with this patch, could you please Ack it, so Mauro
>>>>>>>>> can pull it into media tree with the other two patches in this series,
>>>>>>>>> when he is ready to do so.
>>>>>>>>
>>>>>>>> I *really* want to address the concerns raised by Sakari before pulling more 
>>>>>>>> code that makes fixing the race conditions more difficult. Please, let's all 
>>>>>>>> work on fixing the core code to build a stable base on which we can build 
>>>>>>>> additional features. V4L2 and MC need teamwork, it's time to give the 
>>>>>>>> subsystem the love it deserves.
>>>>>>>>
>>>>>>>
>>>>>>> Hi Laurent,
>>>>>>>
>>>>>>> The issue Sakari brought up is specific to using devm for video_device in
>>>>>>> omap3 and vsp1. I tried reproducing the problem on two different drivers
>>>>>>> and couldn't on Linux 4.9-rc7.
>>>>>>>
>>>>>>> After sharing that with Sakari, I suggested to Sakari to pull up his patch
>>>>>>> that removes the devm usage and see if he still needs all the patches in his
>>>>>>> patch series. He didn't back to me on that. I also requested him to rebase on
>>>>>>
>>>>>> Just to see what remains, I made a small hack to test this with omap3isp by
>>>>>> just replacing the devm_() functions by their plain counterparts. The memory
>>>>>> is thus never released, for there is no really a proper moment to release it
>>>>>> --- something which the patchset resolves. The result is here:
>>>>>>
>>>>>> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg.txt>
>>>>>
>>>>> Did you test this on 4.9-rc7 without any of your other patches? If you
>>>>> haven't could you please run this test with just the removing devm usage
>>>>> from omap3isp?
>>>>>
>>>>> It would be good to get a baseline on the current with just the not using
>>>>> devm first and then see what needs fixing.
>>>>>
>>>>> Also, could you please send me the complete dmesg.
>>>>
>>>> Updated from v4.9-rc6 to rc7 and with increased CONFIG_LOG_BUF_SHIFT. The
>>>> diff and dmesg are here:
>>>>
>>>> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-diff2.txt>
>>>> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
>>>>
>>>
>>> Does unbind work on this even without streaming? Could you suppress
>>
>> It's been working as long as I remember. There are caveats though --- the
>> clock to the sensor is provided by the ISP, so obviously things will not
>> work until the sensor is rebound as well. That is unrelated to the media
>> framework though; just FYI.
>>
>>> debug messages and run unbind without streaming. It might fail. Let
>>> me know if what you see with just unbind on this driver.
>>
>> I don't think disabling debug messages makes a difference but sure I can
>> provide you a log on that. But that'll be tomorrow.
> 
> There you go:
> 
> <URL:http://www.retiisi.org.uk/v4l2/tmp/dmesg-test.txt>

Sakari,

I am changing the subject line and sending a new email about some oddities in
omap3remove sequence. I would have worked on cleaning these up and sending
patches, but I am still working on getting the latest gumstix booting on my
Gumstix overo board. I will spare audio folks from the email barrage of our
debug logs :)

https://github.com/gumstix/linux/tree/master

thanks,
-- Shuah

