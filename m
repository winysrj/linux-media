Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42358 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0ENMSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 08:18:03 -0400
Message-ID: <4BED3F73.3010708@iki.fi>
Date: Fri, 14 May 2010 15:17:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: linux-media@vger.kernel.org
Subject: Re: AF9015 suspend problem
References: <201005021739.18393.jareguero@telefonica.net> <4BEC70FB.5030002@iki.fi> <201005140250.30481.jareguero@telefonica.net>
In-Reply-To: <201005140250.30481.jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2010 03:50 AM, Jose Alberto Reguero wrote:
> El Jueves, 13 de Mayo de 2010, Antti Palosaari escribió:
>> Terve!
>>
>> On 05/02/2010 06:39 PM, Jose Alberto Reguero wrote:
>>> When I have a af9015 DVB-T stick plugged I can not recover from pc
>>> suspend. I must unplug the stick to suspend work. Even if I remove the
>>> modules I cannot recover from suspend.
>>> Any idea why this happen?
>>
>> Did you asked this 7 months ago from me?
>> I did some tests (http://linuxtv.org/hg/~anttip/suspend/) and looks like
>> it is firmware loader problem (fw loader misses something or like
>> that...). No one answered when I asked that from ML, but few weeks ago I
>> saw some discussion. Look ML archives.
>>
>> regards
>> Antti
>
> I think that is another problem. If I blacklist the af9015 driver and have the
> stick plugged in, the suspend don't finish, and the system can't resume. If I
> unplugg the stick the suspend feature work well.

Look these and check if it is same problem:

DVB USB resume from suspend crash
http://www.mail-archive.com/linux-media@vger.kernel.org/msg09974.html

Re: tuner XC5000 race condition??
http://www.mail-archive.com/linux-media@vger.kernel.org/msg18012.html

Bug 15294 -  Oops due to an apparent race between udev and a timeout in 
firmware_class.c
https://bugzilla.kernel.org/show_bug.cgi?id=15294

I haven't examined those yet, but I think they could be coming from same 
issue.

br,
Antti
-- 
http://palosaari.fi/
