Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42758 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZIEURB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 16:17:01 -0400
Received: by bwz19 with SMTP id 19so895390bwz.37
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 13:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9EB592.1030909@gmail.com>
References: <18203149.1251714450755.JavaMail.root@ctps3>
	 <4A9BDDAC.8060304@gmail.com>
	 <a3ef07920908310830w343c3f81g6212d7bcf75858c5@mail.gmail.com>
	 <4A9EB592.1030909@gmail.com>
Date: Sun, 6 Sep 2009 00:17:02 +0400
Message-ID: <1a297b360909051317h1a29fda8w391fa94651fc101d@mail.gmail.com>
Subject: Re: SAA716x driver module
From: Manu Abraham <abraham.manu@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: VDR User <user.vdr@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Sep 2, 2009 at 10:12 PM, Jed<jedi.theone@gmail.com> wrote:
>
>> On Mon, Aug 31, 2009 at 7:26 AM, jed<jedi.theone@gmail.com> wrote:
>>
>>>
>>> Can someone please advise if the SAA716x driver module:
>>> http://www.linuxtv.org/wiki/index.php/NXP_SAA716x#Driver_Development
>>> Is now ready for SAA7162 devices:
>>> http://www.linuxtv.org/wiki/index.php/Saa7162_devices
>>>
>>
>> AFAIK Manu Abraham's driver is the most developed and it doesn't even tune
>> yet.
>
> Actually this appears to suggest otherwise...
> http://jusst.de/hg/saa716x/
> Can anybody comment? Manu preferably! :-D


Sorry about the long delay in the reply being out of station, with a
large mailbox to be processed.

The saa716x driver currently has been tested only on the Technotrend
TT S2 6400 Dual DVB-S2  Premium (a card with H.264 Hardware decoder
and HDMI output and other nice features) for very basic functionality
(tune + stream capture) as of now.

A lot of stuff is still pending.

Regards,
Manu
