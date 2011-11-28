Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1K1Vx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 16:53:26 -0500
Received: by bke11 with SMTP id 11so9113013bke.19
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 13:53:24 -0800 (PST)
Message-ID: <4ED402CF.2010100@gmail.com>
Date: Tue, 29 Nov 2011 00:53:19 +0300
From: Alex <alex.vizor@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2:
 -32 (exp. 2).
References: <4ED29713.1010202@gmail.com> <201111282008.44684.laurent.pinchart@ideasonboard.com> <4ED3DD91.1060505@gmail.com> <201111282020.47745.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111282020.47745.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2011 10:20 PM, Laurent Pinchart wrote:
> Hi Alex,
>
> On Monday 28 November 2011 20:14:25 Alex wrote:
>> On 11/28/2011 10:08 PM, Laurent Pinchart wrote:
>>> On Monday 28 November 2011 19:04:22 Alex wrote:
>>>> Fortunately my laptop is alive now so I'm sending you lsusb output.
>>> Thanks. Would you mind re-running lsusb -v -d '04f2:b221' as root ? What
>>> laptop brand/model is the camera embedded in ?
>>>
>>>> About reverting commit - will try bit later.
>>> I've received reports that reverting the commit helps. A proper patch has
>>> also been posted to the linux-usb mailing list ("EHCI : Fix a regression
>>> in the ISO scheduler"). It would be nice if you could check whether that
>>> fixes your first issue as well.
>> That is lsusb output you asked. Laptop is Thinkpad T420s. Camera works
>> OK with 3.1.x kernel BTW.
> Thank you.
>
>> Could you send this fix patch to me please?
> http://www.spinics.net/lists/linux-usb/msg54992.html
>
> It was the first hit on Google...
>
Laurent,

Seems this patch didn't help I recompiled kernel and still get same error:
[  101.100914] uvcvideo: Failed to query (SET_CUR) UVC control 10 on 
unit 2: -32 (exp. 2).
[  103.900163] uvcvideo: Failed to query (SET_CUR) UVC control 10 on 
unit 2: -32 (exp. 2).
[  103.909735] uvcvideo: Failed to submit URB 0 (-28).
[  107.896939] uvcvideo: Failed to query (SET_CUR) UVC control 10 on 
unit 2: -32 (exp. 2).

Thanks,
Alex
