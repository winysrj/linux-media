Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E2CC1B0F7
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 21:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3940F20896
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547848518;
	bh=KW4nJttlQvjFovpXnajCoUfbQ0aJyQwYaIIZ5EofVpM=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=a+30S1SsJad849i1METYJnysXQGEoFJhzLseWCm2uQGRNV61d0qQz6H/tjv1d7+ei
	 3F+UB1kJHyDwGk3RmukRVVPw1o/bS91wd/qF4lH32WrRpG5Wyai3ZTi2mfp2Ce7KDN
	 Ptj5wu65Ox45djw9dHBmUlQ9oQEJfsTn6L5nEKRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfARVzR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 16:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbfARVzR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 16:55:17 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D492054F;
        Fri, 18 Jan 2019 21:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547848516;
        bh=KW4nJttlQvjFovpXnajCoUfbQ0aJyQwYaIIZ5EofVpM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CnFl+/1xoJIjEnMFAY5RM7E/N++KrhxQ0yI0qZMPqkhL3f4eHfmIG/ct9htJ8j9i3
         dz+kKEGHCiXcVi3yaX0ng/swq1m2YIYxJ7cYYcvKJ5PBKOScgSEzyxs2LjerasEUk8
         yZgrKzP6N7So2vjQl1RM7VgP0GAt9qknfevkiajU=
Subject: Re: [PATCH v9 4/4] sound/usb: Use Media Controller API to share media
 resources
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1545154777.git.shuah@kernel.org>
 <2fb40852e4035b2a58010ce7416448918f12804f.1545154778.git.shuah@kernel.org>
 <b2fddc47-94c6-b7b3-8304-55905a3e278d@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <ee9b4161-eeb8-340f-7b39-93d0bc5fe1bd@kernel.org>
Date:   Fri, 18 Jan 2019 14:54:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <b2fddc47-94c6-b7b3-8304-55905a3e278d@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/18/19 1:36 AM, Hans Verkuil wrote:
> On 12/18/18 6:59 PM, shuah@kernel.org wrote:
>> From: Shuah Khan <shuah@kernel.org>
>>
>> Media Device Allocator API to allows multiple drivers share a media device.
>> This API solves a very common use-case for media devices where one physical
>> device (an USB stick) provides both audio and video. When such media device
>> exposes a standard USB Audio class, a proprietary Video class, two or more
>> independent drivers will share a single physical USB bridge. In such cases,
>> it is necessary to coordinate access to the shared resource.
>>
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
>>
>> Change the ALSA driver to use the Media Controller API to share media
>> resources with DVB, and V4L2 drivers on a AU0828 media device.
>>
>> The Media Controller specific initialization is done after sound card is
>> registered. ALSA creates Media interface and entity function graph nodes
>> for Control, Mixer, PCM Playback, and PCM Capture devices.
>>
>> snd_usb_hw_params() will call Media Controller enable source handler
>> interface to request the media resource. If resource request is granted,
>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>> returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuah@kernel.org>
>> ---
>>   sound/usb/Kconfig        |   4 +
>>   sound/usb/Makefile       |   2 +
>>   sound/usb/card.c         |  14 ++
>>   sound/usb/card.h         |   3 +
>>   sound/usb/media.c        | 321 +++++++++++++++++++++++++++++++++++++++
>>   sound/usb/media.h        |  74 +++++++++
>>   sound/usb/mixer.h        |   3 +
>>   sound/usb/pcm.c          |  29 +++-
>>   sound/usb/quirks-table.h |   1 +
>>   sound/usb/stream.c       |   2 +
>>   sound/usb/usbaudio.h     |   6 +
>>   11 files changed, 455 insertions(+), 4 deletions(-)
>>   create mode 100644 sound/usb/media.c
>>   create mode 100644 sound/usb/media.h
>>
> 
> <snip>
> 
>> +int snd_media_device_create(struct snd_usb_audio *chip,
>> +			struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +	int ret;
>> +
>> +	/* usb-audio driver is probed for each usb interface, and
>> +	 * there are multiple interfaces per device. Avoid calling
>> +	 * media_device_usb_allocate() each time usb_audio_probe()
>> +	 * is called. Do it only once.
>> +	 */
>> +	if (chip->media_dev)
>> +		goto snd_mixer_init;
>> +
>> +	mdev = media_device_usb_allocate(usbdev, KBUILD_MODNAME);
>> +	if (!mdev)
>> +		return -ENOMEM;
>> +
>> +	if (!media_devnode_is_registered(mdev->devnode)) {
> 
> It looks like you missed my comment for v8:
> 
> "You should first configure the media device before registering it."
> 
> In other words, first create the media entities, and only then do you
> register the media device. Otherwise it will come up without any alsa
> entities, which are then added. So an application that immediately
> opens the media device upon creation will see a topology that is still
> in flux.

Yes. You are right. I saw your comment and thought I got it addressed.
I will fix it. I have the logic correct in au0828, but not here.

Thanks,
-- Shuah
