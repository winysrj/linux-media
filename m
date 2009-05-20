Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40236 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZETTTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 15:19:47 -0400
Received: by ewy24 with SMTP id 24so752225ewy.37
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 12:19:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1424F8.9010706@gmail.com>
References: <4A128A19.40601@gmail.com>
	 <37219a840905200608q42b4fc0fife8f9aad7056145b@mail.gmail.com>
	 <4A1424F8.9010706@gmail.com>
Date: Wed, 20 May 2009 15:19:45 -0400
Message-ID: <37219a840905201219x576fe229g6d95f1cf7dc80a08@mail.gmail.com>
Subject: Re: Hauppauge HVR 1110 and DVB
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antonio Beamud Montero <antonio.beamud@gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 20, 2009 at 11:42 AM, Antonio Beamud Montero
<antonio.beamud@gmail.com> wrote:
> Michael Krufky escribió:
>>
>> On Tue, May 19, 2009 at 6:29 AM, Antonio Beamud Montero
>>  Hello,
>>
>> I specifically left out the DVB support for this device.
>>
>> To be honest, I didn't know that this board was available for purchase
>> already.  Where did you get it?  (just curious)
>>
>
> It seems that here in spain is available :)
>
>
>>
>> If something happens sooner than that, I'll append another email to this
>> thread.
>>
>
> Ok, If you need a tester, I'm your man ;)
>
> Thank you.
>
> Greetings.

(i am sending this a second time -- first message got rejected by vger)

You're in luck -- I resolved the problem today...  If you'd like to
test, please try out this repository:

http://kernellabs.com/hg/~mk/hvr1110

Please let me know how this works for you.

Regards,

Mike Krufky
