Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45028 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1LGKsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:48:43 -0500
Received: by eaak14 with SMTP id k14so320498eaa.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 02:48:42 -0800 (PST)
Message-ID: <4EDF4484.5090108@gmail.com>
Date: Wed, 07 Dec 2011 13:48:36 +0300
From: Alex <alex.vizor@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2:
 -32 (exp. 2).
References: <4ED29713.1010202@gmail.com> <201111282020.47745.laurent.pinchart@ideasonboard.com> <4ED402CF.2010100@gmail.com> <201111300251.55083.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111300251.55083.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/2011 04:51 AM, Laurent Pinchart wrote:
> Hi Alex,
>
> On Monday 28 November 2011 22:53:19 Alex wrote:
>> On 11/28/2011 10:20 PM, Laurent Pinchart wrote:
>>> On Monday 28 November 2011 20:14:25 Alex wrote:
>>>> On 11/28/2011 10:08 PM, Laurent Pinchart wrote:
>>>>> On Monday 28 November 2011 19:04:22 Alex wrote:
>>>>>> Fortunately my laptop is alive now so I'm sending you lsusb output.
>>>>> Thanks. Would you mind re-running lsusb -v -d '04f2:b221' as root ?
>>>>> What laptop brand/model is the camera embedded in ?
>>>>>
>>>>>> About reverting commit - will try bit later.
>>>>> I've received reports that reverting the commit helps. A proper patch
>>>>> has also been posted to the linux-usb mailing list ("EHCI : Fix a
>>>>> regression in the ISO scheduler"). It would be nice if you could check
>>>>> whether that fixes your first issue as well.
>>>> That is lsusb output you asked. Laptop is Thinkpad T420s. Camera works
>>>> OK with 3.1.x kernel BTW.
>>> Thank you.
>>>
>>>> Could you send this fix patch to me please?
>>> http://www.spinics.net/lists/linux-usb/msg54992.html
>>>
>>> It was the first hit on Google...
>> Laurent,
>>
>> Seems this patch didn't help I recompiled kernel and still get same error:
>> [  101.100914] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>> unit 2: -32 (exp. 2).
>> [  103.900163] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>> unit 2: -32 (exp. 2).
>> [  103.909735] uvcvideo: Failed to submit URB 0 (-28).
>> [  107.896939] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
>> unit 2: -32 (exp. 2).
> I'm surprised. The patch has been included in 3.1.4, could you please try it ?
>
Laurent,

It works ok with 3.1.4 as with all other 3.1.x version. But doesn't work 
with 3.2-rc4 and previous

Thanks,
Alex
