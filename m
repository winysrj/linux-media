Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61363 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbZJ3Rne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 13:43:34 -0400
Received: by pzk26 with SMTP id 26so2045043pzk.4
        for <linux-media@vger.kernel.org>; Fri, 30 Oct 2009 10:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83bcf6340910280712ue562142i5ef891fe2b701f3d@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
	 <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
	 <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
	 <83bcf6340910270920i4323faf8mb5b482b75bda7291@mail.gmail.com>
	 <8d0bb7650910272244wfdbdda0kae6bec6cd94e2bcc@mail.gmail.com>
	 <83bcf6340910280708t67fdfbffw88dc4594ca527359@mail.gmail.com>
	 <83bcf6340910280712ue562142i5ef891fe2b701f3d@mail.gmail.com>
Date: Fri, 30 Oct 2009 11:43:37 -0600
Message-ID: <8d0bb7650910301043n3ba0b37ja78d78370a9e5ca7@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: dan <danwalkeriv@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Another Sillyname <anothersname@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven,

I tried adding some 2 way splitters for attenuation.  Each one was
-3dB, and I got up to about 5 total, with no change.

I didn't get a chance to try under windows (for various reasons mostly
related to time and lack of a Windows install CD), but I did get some
evidence that it might be the card.  I have a friend at work with the
same card which he has been using without problems for a while now (in
Fedora 10).  He took my card home and swapped it for his working card
and it didn't work.  He said that he got a message saying that the
card couldn't lock and that he could either try waiting longer or try
another channel.  He did both and he still couldn't get a lock.
Unless there is some other reason that you can't just swap two working
HVR-2250s in a working system and have the system still work, I'm
inclined to believe I got a bad one.

--dan


On Wed, Oct 28, 2009 at 8:12 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Wed, Oct 28, 2009 at 10:08 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> On Wed, Oct 28, 2009 at 1:44 AM, dan <danwalkeriv@gmail.com> wrote:
>>> I do have 2 2-way splitters between the card in the wall.  I tried
>>> hooking the card straight to the cable outlet on the wall and ran some
>>> more tests.  It's a little difficult, because there's only one cable
>>> outlet in my whole apartment, and it means doing some re-arranging and
>>> being offline while I'm running the tests.
>>
>> Removing splitters proves it's probably not a weak signal issue (also
>> the SNR or 39 on the TV).  Can you apply some attenuation to reduce
>> the overall rf strength? I'm thinking it's too hot.
>>
>> Something must be using your second tuner, mythtv maybe?
>
> Oh, and please try the card under windows ideally on the same PC using
> the same antenna feed, to rule out any card specific issues.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
