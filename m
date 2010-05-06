Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0EFSJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 14:09:46 -0400
Message-ID: <4BE305DD.5020106@redhat.com>
Date: Thu, 06 May 2010 15:09:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
References: <201001090015.31357.jareguero@telefonica.net> <201001121557.10312.jareguero@telefonica.net> <201001131450.44689.jareguero@telefonica.net> <201001141726.52062.jareguero@telefonica.net>
In-Reply-To: <201001141726.52062.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose Alberto Reguero wrote:
> El Miércoles, 13 de Enero de 2010, Jose Alberto Reguero escribió:
>> El Martes, 12 de Enero de 2010, Jose Alberto Reguero escribió:
>>> El Martes, 12 de Enero de 2010, Jean-Francois Moine escribió:
>>>> On Mon, 11 Jan 2010 15:49:55 +0100
>>>>
>>>> Jose Alberto Reguero <jareguero@telefonica.net> wrote:
>>>>> I take another image with 640x480 and the bad bottom lines are 8. The
>>>>> right side look right this time. The good sizes are:
>>>>> 320x240->320x232
>>>>> 640x480->640x472
>>>> Hi Jose Alberto and Hans,
>>>>
>>>> Hans, I modified a bit your patch to handle the 2 resolutions (also,
>>>> the problem with pas202b does not exist anymore). May you sign or ack
>>>> it?
>>>>
>>>> Jose Alberto, the attached patch is to be applied to the last version
>>>> of the gspca in my test repository at LinuxTv.org
>>>> 	http://linuxtv.org/hg/~jfrancois/gspca
>>>> May you try it?
>>>>
>>>> Regards.
>>>  The patch works well.
>>> There is another problem. When autogain is on(default), the image is bad.
>>>  It is possible to put autogain off by default?
>>>
>>> Thanks.
>>> Jose Alberto
>> Autogain works well again. I can't reproduce the problem. Perhaps the debug
>> messages. (Now I have debug off).
>>
>> Thanks.
>> Jose Alberto
> 
> I found the problem. Autogain don't work well if brightness is de default 
> value(128). if brightness is less(64) autogain work well. There is a problem 
> when setting the brightness. It is safe to remove the brightness control?
> Patch attached.
> 
> Jose Alberto

This patch doesn't apply anymore. I'm not sure if the issue were fixed upstream. If
not, please re-base your patch against my git tree and send it again.

patching file drivers/media/video/gspca/zc3xx.c
Hunk #1 succeeded at 6086 with fuzz 1 (offset 45 lines).
Hunk #2 FAILED at 6882.
1 out of 2 hunks FAILED -- saving rejects to file drivers/media/video/gspca/zc3xx.c.rej
>>> Patch patches/lmml_72895_problem_with_gspca_and_zc3xx.patch doesn't apply

-- 

Cheers,
Mauro
