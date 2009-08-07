Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:55222 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756066AbZHGNXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 09:23:33 -0400
Message-ID: <4A7C2AC0.3040208@email.it>
Date: Fri, 07 Aug 2009 15:23:12 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it>	 <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>	 <4A7B0333.1010901@email.it> <4A7C00DA.1030805@email.it> <829197380908070520y3b5ce05dw61e08fc40d09e4b8@mail.gmail.com>
In-Reply-To: <829197380908070520y3b5ce05dw61e08fc40d09e4b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You are right.
I've opened the device and with the help of a magnifier I've seen that 
it has an EMP202 (at first I've read EMP702 but I've seen that such chip 
does not exist so probably it is an EMP202).
Xwang

Devin Heitmueller ha scritto:
> On Fri, Aug 7, 2009 at 6:24 AM, <xwang1976@email.it> wrote:
>   
>> Just a little addendum.
>> I remember that the audio of analog tv has started to work with Markus'
>> drivers when he added the em28xx-audioep driver because, if I have correctly
>> understood, my device has a  noy standard audio.
>> Is it possible to import the necessary code in the main branch so that to
>> have the device fully functional (today it is unusable to see analog tv
>> because no audio is present).
>> Thank you to all,
>> Xwang
>>     
>
> The dmesg output suggests your device has an EMP202 on the em28xx ac97
> port, which is pretty standard and should be supported by the em28xx
> current audio driver.  I would have to look closer to better
> understand why your audio is not working.
>
> Devin
>
>   
