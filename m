Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50185 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1LJTPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 14:15:32 -0500
Received: by bkcjm19 with SMTP id jm19so202545bkc.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 11:15:31 -0800 (PST)
Message-ID: <4EE3AFC0.5030507@gmail.com>
Date: Sat, 10 Dec 2011 22:15:12 +0300
From: Alex <alex.vizor@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2:
 -32 (exp. 2).
References: <4ED29713.1010202@gmail.com> <201111300251.55083.laurent.pinchart@ideasonboard.com> <4EDF4484.5090108@gmail.com> <201112071208.37000.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112071208.37000.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/07/2011 02:08 PM, Laurent Pinchart wrote:
> Hi Alex,
>
> On Wednesday 07 December 2011 11:48:36 Alex wrote:
>> On 11/30/2011 04:51 AM, Laurent Pinchart wrote:
>>> On Monday 28 November 2011 22:53:19 Alex wrote:
>>>> On 11/28/2011 10:20 PM, Laurent Pinchart wrote:
>>>>> On Monday 28 November 2011 20:14:25 Alex wrote:
>>>>>> On 11/28/2011 10:08 PM, Laurent Pinchart wrote:
>>>>>>> On Monday 28 November 2011 19:04:22 Alex wrote:
>>>>>>>> Fortunately my laptop is alive now so I'm sending you lsusb output.
>>>>>>> Thanks. Would you mind re-running lsusb -v -d '04f2:b221' as root ?
>>>>>>> What laptop brand/model is the camera embedded in ?
>>>>>>>
>>>>>>>> About reverting commit - will try bit later.
>>>>>>> I've received reports that reverting the commit helps. A proper patch
>>>>>>> has also been posted to the linux-usb mailing list ("EHCI : Fix a
>>>>>>> regression in the ISO scheduler"). It would be nice if you could
>>>>>>> check whether that fixes your first issue as well.
>>>>>> That is lsusb output you asked. Laptop is Thinkpad T420s. Camera works
>>>>>> OK with 3.1.x kernel BTW.
>>>>> Thank you.
>>>>>
>>>>>> Could you send this fix patch to me please?
>>>>> http://www.spinics.net/lists/linux-usb/msg54992.html
>>>>>
>>>>> It was the first hit on Google...
>>>> Laurent,
>>>>
>>>> Seems this patch didn't help I recompiled kernel and still get same
>>>> error: [  101.100914] uvcvideo: Failed to query (SET_CUR) UVC control
>>>> 10 on unit 2: -32 (exp. 2).
>>>> [  103.900163] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>>>> unit 2: -32 (exp. 2).
>>>> [  103.909735] uvcvideo: Failed to submit URB 0 (-28).
>>>> [  107.896939] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>>>> unit 2: -32 (exp. 2).
>>> I'm surprised. The patch has been included in 3.1.4, could you please try
>>> it ?
>> Laurent,
>>
>> It works ok with 3.1.4 as with all other 3.1.x version. But doesn't work
>> with 3.2-rc4 and previous
> The fix for the "Failed to submit URB" error is in Linus' tree, and will be in
> v3.2-rc5.
>
It works OK with 3.2-rc5,

Thanks,
Alex
