Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45078 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2ECVyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 17:54:20 -0400
Message-ID: <b37539c729c3a38be7953e4d06f09229.squirrel@webmail.kapsi.fi>
In-Reply-To: <1866189.GQUT4OxER7@jar7.dominio>
References: <4FA293AA.5000601@iki.fi>
    <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
    <1866189.GQUT4OxER7@jar7.dominio>
Date: Fri, 4 May 2012 00:54:16 +0300
From: "Antti Palosaari" <crope@iki.fi>
To: "Jose Alberto Reguero" <jareguero@telefonica.net>
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Antti Palosaari" <antti.palosaari@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: common DVB USB issues we has currently
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

to 3.5.2012 20:03 Jose Alberto Reguero kirjoitti:
> On Jueves, 3 de mayo de 2012 10:48:43 Devin Heitmueller escribió:
>> Hi Antti,
>>
>> > 2)
>> > Suspend/resume is not supported and crashes Kernel. I have no idea
>> what is
>> > wrong here and what is needed. But as it has been long term known
>> problem
>> > I
>> > suspect it is not trivial.
>> >
>> > http://www.spinics.net/lists/linux-media/msg10293.html
>>
>> I doubt this is a dvb-usb problem, but rather something specific to
>> the realtek parts (suspend/resume does work with other devices that
>> rely on dvb-usb).
>>
>> Cheers,
>>
>> Devin
>
> I have the resume problem with the terratec H7.
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45590.html
>
> Jose Alberto

It crashes Kernel for every DVB USB device having DVB USB firmware.

regards
Antti

