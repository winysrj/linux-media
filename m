Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64092 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3KDOjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:39:45 -0500
Received: by mail-ve0-f181.google.com with SMTP id jz11so1501423veb.12
        for <linux-media@vger.kernel.org>; Mon, 04 Nov 2013 06:39:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP_RhzfWKc8y27uU4VXFu6cAt87NvO=BnLNq9WeGG_kpxihTKQ@mail.gmail.com>
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
	<CAC-25o8idLQUjQd9JK-n13bJdOH2riSakfP8GzMqXr=D8NV9CQ@mail.gmail.com>
	<527769FA.9080207@xs4all.nl>
	<CAC-25o9FqkS_g_-RAFn6UuGqKKBhazxtorqzyt=R8ZNDQN23Tw@mail.gmail.com>
	<5277ABA3.3060703@xs4all.nl>
	<CAP_RhzfWKc8y27uU4VXFu6cAt87NvO=BnLNq9WeGG_kpxihTKQ@mail.gmail.com>
Date: Mon, 4 Nov 2013 10:39:44 -0400
Message-ID: <CAC-25o_D+gnBLLVdwWkCEXOgZu2acjwK3g0hj7sx-ZkBG-EG_A@mail.gmail.com>
Subject: Re: [Review Patch 0/9] si4713 usb device driver
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: d ram <dinesh.ram086@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Dinesh Ram <dinesh.ram@cern.ch>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 4, 2013 at 10:21 AM, d ram <dinesh.ram086@gmail.com> wrote:
> Hearty congratulations Eduardo !

Thanks,

> Btw...I didnt get any compilation error for the patch sent by Hans.
> Are you using the trunk version of the kernel?

I've just reset to v3.12 tag. The issue is actually produced by the
patch itself as it moves the macro definition, but still uses it in
the board file.

>
>
> On Mon, Nov 4, 2013 at 3:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 11/04/2013 03:09 PM, edubezval@gmail.com wrote:
>> > Hans,
>> >
>> > On Mon, Nov 4, 2013 at 5:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >> On 10/15/2013 07:37 PM, edubezval@gmail.com wrote:
>> >>> Hello Dinesh,
>> >>>
>> >>> On Tue, Oct 15, 2013 at 11:24 AM, Dinesh Ram <dinesh.ram@cern.ch>
>> >>> wrote:
>> >>>> Hello Eduardo,
>> >>>>
>> >>>> In this patch series, I have addressed the comments by you
>> >>>> concerning my last patch series.
>> >>>> In the resulting patches, I have corrected most of the
>> >>>> style issues and adding of comments. However, some warnings
>> >>>> given out by checkpatch.pl (mostly complaing about lines longer
>> >>>> than 80 characters) are still there because I saw that code
>> >>>> readibility
>> >>>> suffers by breaking up those lines.
>> >>>>
>> >>>> Also Hans has contributed patches 8 and 9 in this patch series
>> >>>> which address the issues of the handling of unknown regulators,
>> >>>> which have apparently changed since 3.10. Hans has tested it and the
>> >>>> driver loads again.
>> >>>>
>> >>>> Let me know when you are able to test it again.
>> >>>>
>> >>>
>> >>> Hopefully I will be able to give it a shot on n900 and on silabs
>> >>> devboard until the end of the week. Thanks for not giving up.
>> >>
>> >> Did you find time to do this? I'm waiting for feedback from you.
>> >
>> > sorry for the late answer, I was offline for two weeks taking care of
>> > my newborn  son :-).
>>
>> An excellent reason! Congratulations!
>>
>>         Hans
>>
>> >
>> > I am giving the series a second shot.
>> >
>> >>
>> >> Regards,
>> >>
>> >>         Hans
>> >
>> >
>> >
>>
>



-- 
Eduardo Bezerra Valentin
