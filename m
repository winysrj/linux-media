Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1343 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZEDSbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 14:31:17 -0400
Message-ID: <57876.62.70.2.252.1241461874.squirrel@webmail.xs4all.nl>
Date: Mon, 4 May 2009 20:31:14 +0200 (CEST)
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
       2.6.16-2.6.21: ERRORS
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello, Hans
>
> On Mon, May 4, 2009 at 10:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This message is generated daily by a cron job that builds v4l-dvb for
>> the kernels and architectures in the list below.
>>
>> Results of the daily build of v4l-dvb:
>>
>> date:        Mon May  4 19:00:02 CEST 2009
>> path:        http://www.linuxtv.org/hg/v4l-dvb
>> changeset:   11658:83712d149893
>> gcc version: gcc (GCC) 4.3.1
>
> Sorry for bothering, but in the letter called "Daily build: updated
> with new gcc and binutils" you said that you updated gcc version to
> 4.4.0. So, is there any mistake? Looks like 4.3.1 here.

That's confusing: this refers to the host compiler version, not the
version I use for cross-compiling and for doing the actual v4l-dvb tree
builds. I'll see if I can improve this log output.

Regards,

        Hans

>
> --
> Best regards, Klimov Alexey
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

