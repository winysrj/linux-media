Return-path: <linux-media-owner@vger.kernel.org>
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:48752 "EHLO
	6.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbcHDQk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 12:40:58 -0400
Received: from player788.ha.ovh.net (b7.ovh.net [213.186.33.57])
	by mo68.mail-out.ovh.net (Postfix) with ESMTP id 8BFFEFF8C31
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2016 17:21:43 +0200 (CEST)
Subject: Re: [PATCH] V4L2: Add documentation for SDI timings and related flags
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1469113476-1645-1-git-send-email-charles-antoine.couret@nexvision.fr>
 <080c0d20-6268-f1a0-9120-d6e4909bdcd5@xs4all.nl>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Message-ID: <58f6ea73-e54a-a0f7-305e-2740f5a8bfba@nexvision.fr>
Date: Thu, 4 Aug 2016 17:21:42 +0200
MIME-Version: 1.0
In-Reply-To: <080c0d20-6268-f1a0-9120-d6e4909bdcd5@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 04/08/2016 à 12:11, Hans Verkuil a écrit :

>> --- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>> @@ -339,6 +339,13 @@ EBUSY
>>  
>>         -  The timings follow the VESA Generalized Timings Formula standard
>>  
>> +    -  .. row 7
>> +
>> +       -  ``V4L2_DV_BT_STD_SDI``
>> +
>> +       -  The timings follow the SDI Timings standard.
>> +	  There are no horizontal syncs/porches at all in this format.
>> +	  Total blanking timings must be set in hsync or vsync fields only.
> 
> Didn't you mention on irc that there are actually two blanking timings for
> vertical blanking? Something frontporch like? I can't remember the details,
> but if I remember correctly, then you should specify what goes where.


Yes, your're right about this.
In SMPTE 125M (I like this standard :D), some "frontporchs" or similar values are available.
So, I can precise that in the documentation and fix SMPTE 125M definition to take this into account.

Thank you very much.
Regards,
Charles-Antoine Couret
