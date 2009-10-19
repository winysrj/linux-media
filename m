Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63010 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZJSTj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 15:39:57 -0400
Received: by fxm18 with SMTP id 18so5488551fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 12:40:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091020042913.1d3609d7@caramujo.chehab.org>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
	 <20091020042913.1d3609d7@caramujo.chehab.org>
Date: Mon, 19 Oct 2009 21:40:00 +0200
Message-ID: <d9def9db0910191240g163f04aau631ec481ec6bdf70@mail.gmail.com>
Subject: Re: ISDB-T tuner
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Romont Sylvain <psgman24@yahoo.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 19, 2009 at 9:29 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Hi Romont,
>
> Em Mon, 19 Oct 2009 12:16:30 +0000 (GMT)
> Romont Sylvain <psgman24@yahoo.fr> escreveu:
>
>> Hello!
>>
>> I actually live in Japan, I try to make working a tuner card ISDB-T with
>> linux. I searched a lot in internet but I find nothing....
>> How can I make it working?
>> My tuner card is a Pixela PIXDT090-PE0
>> in picture here:  http://bbsimg01.kakaku.com/images/bbs/000/208/208340_m.jpg
>>
>> Thank you for your help!!!
>
> Unfortunately, only the Earthsoft PC1 board and the boards with dibcom 80xx USB
> boards are currently supported. In the case of Dibcom, it can support several
> different devices, but we may need to add the proper USB ID for the board at the driver.
>
> I'm in Japan during this week for the Kernel Summit and Japan Linux Symposium.
>
> One of objectives I'm expecting from this trip is to get more people involved on
> creating more drivers for ISDB and other Asian digital video standards.
>

Here we can add that we also have fully working Hybrid/ISDB-T USB
fullseg devices for Linux already, just in case someone is interested
in it.
Feel free to contact me to get some more information about it. The
driver works from Linux 2.6.15 on (easy installation everywhere
without compiling).

Best Regards,
Markus
