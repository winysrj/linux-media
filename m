Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy001.phy.lolipop.jp ([157.7.104.42]:57756 "EHLO
	smtp-proxy001.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277AbcFUCbx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 22:31:53 -0400
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
To: Henrik Austad <henrik@austad.us>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <20160613114713.GA9544@localhost.localdomain> <20160613195136.GC2441@netboy>
 <20160614121844.54a125a5@lxorguk.ukuu.org.uk> <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <5766B01B.9070903@sakamocchi.jp>
 <20160620090656.GB8011@sisyphus.home.austad.us>
Cc: Richard Cochran <richardcochran@gmail.com>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	Arnd Bergmann <arnd@linaro.org>, linux-media@vger.kernel.org
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Message-ID: <5768A4DA.1030809@sakamocchi.jp>
Date: Tue, 21 Jun 2016 11:22:18 +0900
MIME-Version: 1.0
In-Reply-To: <20160620090656.GB8011@sisyphus.home.austad.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016年06月20日 18:06, Henrik Austad wrote:
> On Sun, Jun 19, 2016 at 11:45:47PM +0900, Takashi Sakamoto wrote:
>> (remove C.C. to lkml. This is not so major feature.)
>>
>> On Jun 19 2916 07:45, Henrik Austad wrote:
>>> snip
>>>
>>> 802.1Q gives you low latency through the network, but more importantly, no
>>> dropped frames. gPTP gives you a central reference to time.
>>
>> When such a long message is required, it means that we don't have
>> enough premises for this discussion.
>
> Isn't a discussion part of how information is conveyed and finding parts
> that require more knowledge?
>
>> You have just interests in gPTP and transferring AVTPDUs, while no
>> interests in the others such as "what the basic ideas of TSN come
>> from" and "the reason that IEEE 1722 refers to IEC 61883 series
>> which is originally designed for IEEE 1394 bus" and "the reason that
>> I was motivated to join in this discussion even though not a netdev
>> developer".
>
> I'm sorry, I'm not sure I follow you here. What do you mean I don't have
> any interest in where TSN comes from? or the reason why 1722 use IEC 61883?
> What about "they picked 61883 because it made sense?"
>
> gPTP itself is *not* about transffering audio-data, it is about agreeing on
> a common time so that when you *do* transfer audio-data, the samplerate
> actually means something.
>
> Let me ask you this; if you have 2 sound-cards in your computer and you
> want to attach a mic to one and speakers to the other, how do you solve
> streaming of audio from the mic to the speaker If you answer does not
> contain something akin to "different timing-domain issues", I'd be very
> surprised.
>
> If you are interested in TSN for transferring *anything*, _including_
> audio, you *have* to take gPTP into consideration. Just as you have to
> think about stream reservation, compliant hardware and all the different
> subsystems you are going to run into, either via kernel or via userspace.
>
>> Here, could I ask you a question? Do you know a role of cycle start
>> packet of IEEE Std 1394?
>
> No, I do not.
>
> I have only passing knowledge of the firewire standard, I've looked at the
> encoding described in 1722 and added that to the alsa shim as an example of
> how to use TSN. As I stated, this was a *very* early version and I would
> like to use TSN for audio - and more work is needed.
>
>> If you think it's not related to this discussion, please tell it to
>> me. Then I'll drop out from this thread.
>
> There are tons of details left and right, and as I said, I'm not  all to
> familiar with firewire. I know that one of the authors behind the firewire
> standard happened to be part of 1722 standard.
>
> I am currently working my way through the firewire-stak paper you've
> written, and I have gotten a lot of pointers to other areas I need to dig
> into so I should be busy for a while.
>
> That being said, Richard's point about a way to find sample-rate of a
> hardware device and ways to influence that, is important for AVB/TSN.
>
>> History Repeats itself.
>
> ?

OK. Bye.


Takashi Sakamoto
