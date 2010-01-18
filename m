Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:27658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0ARQ3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 11:29:05 -0500
Received: by fg-out-1718.google.com with SMTP id 22so775461fge.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 08:29:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001180817r561bb1cdj9edda6ab3affbba0@mail.gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
	 <829197380912220750j116894baw8343010b123f929@mail.gmail.com>
	 <ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
	 <ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
	 <829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com>
	 <4B54864E.1050801@yahoo.it>
	 <829197381001180817r561bb1cdj9edda6ab3affbba0@mail.gmail.com>
Date: Mon, 18 Jan 2010 17:29:03 +0100
Message-ID: <d9def9db1001180829n733471c6g375295f29fc349ea@mail.gmail.com>
Subject: Re: Info
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Adriano Gigante <adrigiga@yahoo.it>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 5:17 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Jan 18, 2010 at 11:03 AM, Adriano Gigante <adrigiga@yahoo.it> wrote:
>> Hi Devin,
>>>
>>> The 0ccd:0043 is on my todo list of devices to work on (they sent me a
>>> sample board), although it's not the highest priority on my list given
>>> how old it is.
>>>
>>
>> Did they sent you also a 0ccd:0072 card (Terratec Cinergy Hybrid T USB XS
>> FM)?
>> Adri
>
> Terratec sent me two boards:  0ccd:0072 and 0ccd:0043.  I've actually
> been working with a user on the #linuxtv irc channel who is in the
> process of getting the 0ccd:0072 board to work (username Prahal).
> He's making great progress, but if he gets stuck I will find some
> cycles to work through whatever problem he finds.
>

Just fyi there's a hardware bug with the 0072/terratec hybrid xs fm
(cx25843 - xc5000):

http://img91.imageshack.us/i/00000004qf8.png/
http://img104.imageshack.us/i/00000009cp4.png/

nothing that can be fixed with the driver.

Markus
