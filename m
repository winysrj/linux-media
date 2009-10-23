Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:59120 "HELO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751641AbZJWNgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 09:36:36 -0400
Received: by bwz25 with SMTP id 25so1017971bwz.18
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 06:36:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aaaa95950910230035o4c07c955jbbe74a80f79d6d69@mail.gmail.com>
References: <aaaa95950910210632p74179cv91aa9825eff8d6bd@mail.gmail.com>
	 <aaaa95950910220813y71f2f328sdb53d5c594d93094@mail.gmail.com>
	 <aaaa95950910220851l201870c8w5352f2ec889244eb@mail.gmail.com>
	 <095c6478b6c5187393b7af198449545f.squirrel@webmail.xs4all.nl>
	 <aaaa95950910230035o4c07c955jbbe74a80f79d6d69@mail.gmail.com>
Date: Fri, 23 Oct 2009 15:36:39 +0200
Message-ID: <aaaa95950910230636o64ce8946re1dd19282e622370@mail.gmail.com>
Subject: Re: [PATCH] output human readable form of the .status field from
	VIDIOC_ENUMINPUT
From: Sigmund Augdal <sigmund@snap.tv>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 23, 2009 at 9:35 AM, Sigmund Augdal <sigmund@snap.tv> wrote:
> On Fri, Oct 23, 2009 at 12:10 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> The attach patch modifies v4l2-ctl -I to also output signal status as
>>> detected by the driver/hardware. This info is available in the status
>>> field of the data returned by VIDIOC_ENUMINPUT which v4l2-ctl -I
>>> already calls. The strings are copied from the v4l2 api specification
>>> and could perhaps be modified a bit to fit the application.
>>>
>>> Best regards
>>>
>>> Sigmund Augdal
>>>
>>
>> Hi Sigmund,
>>
>> This doesn't work right: the status field is a bitmask, so multiple bits
>> can be set at the same time. So a switch is not the right choice for that.
>> Look at some of the other functions to print bitmasks in v4l2-ctl.cpp for
>> ideas on how to implement this properly.
>>
>> But it will be nice to have this in v4l2-ctl!
> Right, I realized this shortly after sending. I'll take a look at this
> today. However, I'm unsure how to handle the value 0. It seems this is
> used both for "signal detected and everything is ok" and "driver has
> no clue if there is a signal or not". Any feedback welcome.
Attached is my second attempt at this. It should be slightly cleaner.
I also changed the output format a bit so the line containing input
name is unchanged compared to current v4l2-ctl (in case anyone has
scripts that depend on it). Now signal status is outputted on a new
line.

Best regards

Sigmund Augdal
>
> Best regards
>
> Sigmund Augdal
>>
>> Regards,
>>
>>      Hans
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>
>>
>
