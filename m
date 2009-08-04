Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:47925 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbZHDVXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 17:23:32 -0400
Received: by fg-out-1718.google.com with SMTP id e12so762386fga.17
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 14:23:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908041312.52878.jareguero@telefonica.net>
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
	 <200908041312.52878.jareguero@telefonica.net>
Date: Tue, 4 Aug 2009 23:23:31 +0200
Message-ID: <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com>
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
	mythbuntu 9.04
From: Cyril Hansen <cyril.hansen@gmail.com>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you very much, your patch has fixed the issue i had using the
firmware provided by mythbuntu.

Maybe we should add this info to the LinuxTV wiki.

Regards,

Cyril Hansen

2009/8/4 Jose Alberto Reguero <jareguero@telefonica.net>:
> El Martes, 4 de Agosto de 2009, Cyril Hansen escribió:
>> Hi all,
>>
>> I am trying to solve a noisy video issue with my new avermedia stick
>> (AF9015). I am receiving french DVB signal, both SD and HD. Viewing SD
>> is annoying, with the occasional video and audio quirk, and HD is
>> almost unwatchable.
>>
>> The same usb stick with another computer and Vista gives a perfect
>> image with absolutely no error from the same antenna.
>>
>> Yesterday I tried to update the drivers from the mercurial tree with no
>> change.
>>
>> I noticed that the firmware available from the Net and Mythbuntu for
>> the chip is quite old (2007 ?), so maybe this is the source of my
>> problem. I am willing to try to use usbsnoop and the firmware cutter
>> from
>>
>> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_fi
>>les/ if nobody has done it with a recent windows driver.
>>
>>
>> I haven't found any parameter for the module dvb_usb_af9015 : Are they
>> any than can be worth to try to fix my issue ?
>>
>>
>> Thank you in advance,
>>
>> Cyril Hansen
>> --
>
> I have problems with some hardware, and the buffersize when the buffersize is
> not multiple of TS_PACKET_SIZE.
>
> You can try the attached patch.
>
> Jose Alberto
>
>
