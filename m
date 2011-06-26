Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42519 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1FZQdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 12:33:37 -0400
Received: by iwn6 with SMTP id 6so3535228iwn.19
        for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 09:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim5hK-hbhon-cbay5S9iimqEbVQkQ@mail.gmail.com>
References: <BANLkTim5hK-hbhon-cbay5S9iimqEbVQkQ@mail.gmail.com>
Date: Sun, 26 Jun 2011 18:33:37 +0200
Message-ID: <BANLkTinzwaeVFK+BD4UbLwVDYEOVti8AXg@mail.gmail.com>
Subject: Re: Committing a new file for channels list : fr-Lille-Bouvigny
From: Christoph Pfister <christophpfister@gmail.com>
To: Xavier Poirot <xavier@dalaen.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/9 Xavier Poirot <xavier@dalaen.com>:
> Hi here,
>
> I have noticed that files for French City Lille is not up-to-date.
> There is only files provided for Lambersart transmitter. But this one
> has been shot down a few months ago.
>
> The only transmitter in the area working is the one of Bouvigny.
>
> I have updated Lambersart's file to Bouvigny frequencies in the attached file.
<c&p>
> T 490000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> T 690000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> T 514000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> T 546000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> T 554000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> T 586000000 8MHz AUTO NONE QAM64 8k AUTO NONE

Please use http://linuxtv.org/hg/dvb-apps/file/tip/util/scan/dvb-t/auto-Default
instead. DVB-T scan files shouldn't contain any "AUTO" entries (logic:
if a device can handle AUTO parameters, you can also use auto-Default;
it takes a bit more time, but it's way easier to maintain).

Christoph


> BUGS : Not every frequencies are working good. Maybe it is only my
> aerial, I cannot really figure out.
>
> Of course, please let me know for _ANY_ more details, I am willing to
> help you :)
>
> Xavier Poirot
> Lille / FRANCE & Hillerød / DANMARK
