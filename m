Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbAOKy1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 05:54:27 -0500
Message-ID: <54B79C60.3050309@redhat.com>
Date: Thu, 15 Jan 2015 11:54:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_stv06xx: enable button found on some Quickcam Express
 variant
References: <1405083417-20615-1-git-send-email-ao2@ao2.it>	<53C3B0AD.7070001@redhat.com>	<20141028153941.8298e540ddf03796246c6f26@ao2.it> <20150106215925.03aafecd952a176b3f376a2d@ao2.it>
In-Reply-To: <20150106215925.03aafecd952a176b3f376a2d@ao2.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06-01-15 21:59, Antonio Ospite wrote:
> On Tue, 28 Oct 2014 15:39:41 +0100
> Antonio Ospite <ao2@ao2.it> wrote:
>
>> On Mon, 14 Jul 2014 12:27:57 +0200
>> Hans de Goede <hdegoede@redhat.com> wrote:
>>
>>> Hi,
>>>
>>> On 07/11/2014 02:56 PM, Antonio Ospite wrote:
>>>> Signed-off-by: Antonio Ospite <ao2@ao2.it>
>>>
>>> Thanks, I've added this to my tree and send a pull-req for it
>>> to Mauro.
>>>
>>
>> Hi Hans, I still don't see the change in 3.18-rc2, maybe it got lost.
>>
>> Here is the patchwork link in case you want to pick the change for 3.19:
>> https://patchwork.linuxtv.org/patch/24732/
>>
>
> Ping.
>
> Still missing in 3.19-rc3.

Yes, weird, I had it in a pull-req for 3.17:

http://git.linuxtv.org/cgit.cgi/hgoede/gspca.git/log/?h=media-for_v3.17

Anyways I've queued it up for 3.20 now.

Regards,

Hans
