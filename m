Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56801 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1KGWT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 17:19:56 -0500
Received: by mail-gy0-f174.google.com with SMTP id 15so4656389gyc.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 14:19:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EB7F048.1050307@redhat.com>
References: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com>
 <201110281442.21776.laurent.pinchart@ideasonboard.com> <4EAB2CF4.4040007@gmail.com>
 <201110290952.17916.laurent.pinchart@ideasonboard.com> <4EB7F048.1050307@redhat.com>
From: Gilles Gigan <gilles.gigan@gmail.com>
Date: Tue, 8 Nov 2011 09:19:33 +1100
Message-ID: <CAJWu0HNtJukPLjcRU1m6=P5dTo7DAgNozqLZreMCVXZZzTRSbQ@mail.gmail.com>
Subject: Re: Switching input during capture
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Tue, Nov 8, 2011 at 1:50 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 29-10-2011 05:52, Laurent Pinchart escreveu:
>> Hi Mauro,
>>
>> On Saturday 29 October 2011 00:30:12 Mauro Carvalho Chehab wrote:
>>> Em 28-10-2011 14:42, Laurent Pinchart escreveu:
>>>> On Friday 28 October 2011 03:31:53 Gilles Gigan wrote:
>>>>> Hi,
>>>>> I would like to know what is the correct way to switch the current
>>>>> video input during capture on a card with a single BT878 chip and 4
>>>>> inputs
>>>>> (http://store.bluecherry.net/products/PV%252d143-%252d-4-port-video-capt
>>>>> ur e-card-%2830FPS%29-%252d-OEM.html). I tried doing it in two ways: -
>>>>> using VIDIOC_S_INPUT to change the current input. While this works, the
>>>>> next captured frame shows video from the old input in its top half and
>>>>> video from the new input in the bottom half.
>>>
>>> This is is likely easy to fix. The driver has already a logic to prevent
>>> changing the buffer while in the middle of a buffer filling. I suspect
>>> that the BKL removal patches might have broken it somewhat, allowing
>>> things like that. basically, it should be as simple as not allowing
>>> changing the input at the top half.
>>
>> This will work optimally only if the input analog signals are synchronized,
>> right ? If we switch to a new input right when the frame start, can the first
>> frame captured on the new input be corrupted ?
>
> That's a good question. I'm not sure how those bttv cards solve it, but as
> they're widely used on such configurations, I suspect that the hardware used
> on those CCTV boards have some logic to keep them in sync.
>
>>
>>> Please try the enclosed patch.
>>>
>>> Regards,
>>> Mauro
>>>
>>> -
>>>
>>> bttv: Avoid switching the video input at the top half.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>
>>> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
>>> b/drivers/media/video/bt8xx/bttv-driver.c index 3dd0660..6a3be6f 100644
>>> --- a/drivers/media/video/bt8xx/bttv-driver.c
>>> +++ b/drivers/media/video/bt8xx/bttv-driver.c
>>> @@ -3978,7 +3978,7 @@ bttv_irq_switch_video(struct bttv *btv)
>>>      bttv_set_dma(btv, 0);
>>>
>>>      /* switch input */
>>> -    if (UNSET != btv->new_input) {
>>> +    if (! btv->curr.top && UNSET != btv->new_input) {
>>>              video_mux(btv,btv->new_input);
>>>              btv->new_input = UNSET;
>>>      }
>>
>
>

I am yet to try the above patch myself, but I have received feedback
from another user and it seems it does not solve the issue.
Will keep you posted as soon as I got around to testing it.
Thanks
Gilles
