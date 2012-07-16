Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34700 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2GPNc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 09:32:58 -0400
Received: by bkwj10 with SMTP id j10so4660971bkw.19
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2012 06:32:57 -0700 (PDT)
Message-ID: <50041806.7000406@googlemail.com>
Date: Mon, 16 Jul 2012 15:32:54 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [Regression 3.1->3.2, bisected] UVC-webcam: kernel panic when
 starting capturing
References: <4FFF208C.5030306@googlemail.com> <11675039.R7p149JEZD@avalon> <50031C83.7060703@googlemail.com> <1649650.cNT61xzOAf@avalon>
In-Reply-To: <1649650.cNT61xzOAf@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.07.2012 01:24, schrieb Laurent Pinchart:
> Hi Frank,
>
> On Sunday 15 July 2012 21:39:47 Frank Schäfer wrote:
>> Am 15.07.2012 14:07, schrieb Laurent Pinchart:
>>> On Thursday 12 July 2012 21:07:56 Frank Schäfer wrote:
>>>> Hi,
>>>>
>>>> when I start capturing from the UVC-webcam 2232:1005 ("WebCam
>>>> SCB-0385N") of my netbook, I get a kernel panic.
>>>> You can find a screenshot of the backtrace here:
>>>>
>>>> http://imageshack.us/photo/my-images/9/img125km.jpg/
>>>>
>>>> This is a regression which has been introduced between kernel 3.2-rc2
>>>> and 3.2-rc3 with the following commit:
>>>>
>>>> 3afedb95858bcc117b207a7c0a6767fe891bdfe9 is the first bad commit
>>>> commit 3afedb95858bcc117b207a7c0a6767fe891bdfe9
>>>> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> Date:   Thu Nov 3 07:24:34 2011 -0300
>>>>
>>>>     [media] uvcvideo: Don't skip erroneous payloads
>>>>     
>>>>     Instead of skipping the payload completely, which would make the
>>>>     resulting image corrupted anyway, store the payload normally and mark
>>>>     the buffer as erroneous. If the no_drop module parameter is set to 1
>>>>     the buffer will then be passed to userspace, and tt will then be up
>>>>     to the application to decide what to do with the buffer.
>>>>
>>>>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> I'm puzzled. Your screenshot shows the uvc_video_stats_decode() function
>>> in the stack trace, but that function wasn't present in
>>> 3afedb95858bcc117b207a7c0a6767fe891bdfe9. Could you please send me a stack
>>> trace corresponding to 3afedb95858bcc117b207a7c0a6767fe891bdfe9 ?
>>>
>>> Your stack trace looks similar to the problem reported in
>>> https://bugzilla.redhat.com/show_bug.cgi?id=836742.
>>> 3afedb95858bcc117b207a7c0a6767fe891bdfe9 might have introduced a different
>>> bug, possibly fixed in a later commit.
>> Hmm... you're right.
>> The screenshot I've sent to you was made during the bisection process at
>> a commit somewhere between 3.2-rc7 and 3.2-rc8.
>> It seems that this one is slightly different from the others.
>>
>> This one is made at commit 3afedb95858bcc117b207a7c0a6767fe891bdfe9 (the
>> first bad commit):
>>
>> http://imageshack.us/photo/my-images/811/img130hv.jpg
>>
>> and this one is made at 3.5.rc6+:
>>
>> http://imageshack.us/photo/my-images/440/img127u.jpg
> Thank you. Could you please try the patch I've attached to 
> https://bugzilla.redhat.com/show_bug.cgi?id=836742 ?
>

Thank you Laurent, I can confirm that this patch fixes the bug !
Don't forget to add CC-stable (and a comment that this should be applied
to all kernels >=3.2 ?).

Regards,
Frank Schäfer




