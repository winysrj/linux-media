Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38454 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1HRNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 09:04:04 -0400
Received: by wyg24 with SMTP id 24so1381897wyg.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 06:04:03 -0700 (PDT)
Message-ID: <4E4D0DBE.3020805@grawet.be>
Date: Thu, 18 Aug 2011 15:03:58 +0200
From: Laurent Grawet <laurent.grawet@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Bug: Kernel oops with Kopete due to DVB device
References: <4E38520F.4070809@grawet.be> <4E39B86C.3040003@grawet.be>
In-Reply-To: <4E39B86C.3040003@grawet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/11 23:06, Laurent Grawet wrote:
> On 02/08/11 21:37, Laurent Grawet wrote:
>> Bug initially submitted to https://bugs.kde.org/show_bug.cgi?id=279202
>>
>> Hello,
>>
>> Kopete crash and kernel oopses when opening "Settings -> Configure" dialog
>> due to presence of DVB-S PCI card (av7110) as /dev/video0. This happens 
>> everytime I try to configure Kopete in presence of my DVB PCI card. 
>> (see attachment)
>>
>> Reproducible: Always
>>
>> Steps to Reproduce:
>> Own a DVB card and try to configure Kopete.
>>
>> Actual Results:  
>> Kopete crash and Kernel oopses.
>>
>> Expected Results:  
>> Configure dialog opening.
> Cheese gnome app also get into trouble. No kernel oops but the machine
> get unresponsive and quickly begins to swap like hell until I kill
> cheese. I don't have this problem when I plug my USB uvc webcam.
> Probably because this is the first device picked up by kopete or cheese.
> But as soon I try to configure the DVB device in kopete, kernel oops...

The bug is also present in 3.0 kernel.

Laurent
