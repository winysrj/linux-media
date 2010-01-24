Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56682 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0AXHtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 02:49:12 -0500
Received: by bwz27 with SMTP id 27so1972356bwz.21
        for <linux-media@vger.kernel.org>; Sat, 23 Jan 2010 23:49:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361001231543g7bde6ac8qc6e8048173f07492@mail.gmail.com>
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>
	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>
	 <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>
	 <4B49D1A4.4040702@gmail.com>
	 <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com>
	 <846899811001100728x27eaf4faqd83373dd16ef58d3@mail.gmail.com>
	 <4B4A0C95.5000804@sgtwilko.f9.co.uk>
	 <1a297b361001221531q4a2726ecm5952379c6ef08182@mail.gmail.com>
	 <8103ad501001231345l24316554j12c7a45de58f7f3b@mail.gmail.com>
	 <1a297b361001231543g7bde6ac8qc6e8048173f07492@mail.gmail.com>
Date: Sun, 24 Jan 2010 09:49:04 +0200
Message-ID: <8103ad501001232349h24377ef8j9a052f69d0d4da55@mail.gmail.com>
Subject: Re: CI USB
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Ian Wilkinson <null@sgtwilko.f9.co.uk>, HoP <jpetrous@gmail.com>,
	Emmanuel <eallaud@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 24, 2010 at 1:43 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Sun, Jan 24, 2010 at 1:45 AM, Konstantin Dimitrov
> <kosio.dimitrov@gmail.com> wrote:
>> On Sat, Jan 23, 2010 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> On Sun, Jan 10, 2010 at 9:21 PM, Ian Wilkinson <null@sgtwilko.f9.co.uk> wrote:
>>>> HoP wrote:
>>>>
>>>> I don't know the details into the USB device, but each of those CAM's
>>>> have bandwidth limits on them and they vary from one CAM to the other.
>>>> Also, there is a limit on the number of simultaneous PID's that which
>>>> you can decrypt.
>>>>
>>>> Some allow only 1 PID, some allow 3. Those are the basic CAM's for
>>>> home usage.The most expensive CAM's allow a maximum of 24 PID's. But
>>>>
>>>>
>>>> You, of course, ment number of descramblers not PIDS because it is evident
>>>> that getting TV service descrambled, you need as minimum 2 PIDS for A/V.
>>>>
>>>> Anyway, it is very good note. Users, in general, don't know about it.
>>>>
>>>
>>> If it is using a CI+ plus chip (I heard from someone that it is a CI+
>>> chip inside) :
>>> http://www.smardtv.com/index.php?page=ciplus
>>>
>>> After reading the CI+ specifications, I doubt that it can be supported
>>> under Linux with open source support, without a paired decoder
>>> hardware or software decoder. A paired open source software decoder
>>> seems highly unlikely, as the output of the CI+ module is eventually
>>> an encrypted stream which can be descrambled with the relevant keys.
>>> The TS is not supposed to be stored on disk, or that's what the whole
>>> concept is for CI+
>>>
>>> http://www.ci-plus.com/data/ci-plus_overview_v2009-07-06.pdf
>>>
>>> See pages 7, 8 , 12, 15
>>>
>>> It could be possible to pair a software decoder with a key and hence
>>> under Windows, but under Linux I would really doubt it, if it happens
>>> to be a CI+ chip
>>
>> at least in Windows Hauppage WinTV-CI USB (which is OEM version of
>> SmartDTV USB CI) allows you to capture the decrypted stream to your
>> hard drive (i've just tested it).
>
>
> Maybe it is not CI+ itself in the first place
>
>
>> so, i can't see a reason why even if it has CI+ chip inside same
>> functionally as in Windows can't be provided in Linux if someone
>> developed a driver.
>
>
> It would be interesting to know what chips the hardware has  ...

i can confirm the information here:

* http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-CI

and it contains:

* "an FX2 from Cypress (CY7C68013A) and a FPGA (Actel Proasic-plus, APA075-F)"

also, i can confirm that firmware extractor here:

http://www.bsc-bvba.be/linux/dvb/

is correct at least for A2 hardware (but A1 hardware is no longer in
production anyway), because a long time ago i verified with spying the
USB traffic what firmware is uploaded in Windows for A2 hardware and
informed Luc Brosens and he fixed his firmware extractor tool.

however, it seems that the main problem as it's mentioned by Luc
Brosens is why firmware upload fails in Linux, because according to
Steven Toth words:

* http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025284.html

* "I also looked at the USB traffic on the current Hauppauge driver, with a
* cam inserted and decryption happening. The protocol appears pretty simple."

after the firmware is uploaded is easy to figure out how to send
commands to the device.

>
> Regards,
> Manu
>
