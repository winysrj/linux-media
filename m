Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0KTQ5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 11:57:45 -0500
Received: by bwz15 with SMTP id 15so4857080bwz.19
        for <linux-media@vger.kernel.org>; Sat, 20 Nov 2010 08:57:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ibqclc$q5u$1@dough.gmane.org>
References: <AANLkTinWJu92nCR4vHUO3MWZp_ipNZL8LzpYrU4GDj7U@mail.gmail.com>
	<ibqclc$q5u$1@dough.gmane.org>
Date: Sat, 20 Nov 2010 17:57:43 +0100
Message-ID: <AANLkTi=iLjVzq2T61FkPEEMdPKXd6L9Va5_L0JjkhN5J@mail.gmail.com>
Subject: Re: For those that uses Pinnacle PCTV 340e
From: Magnus Alm <magnus.alm@gmail.com>
To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

2010/11/15 Mohammad Bahathir Hashim <bahathir@gmail.com>:
> On 2010-11-14, Magnus Alm <magnus.alm@gmail.com> wrote:
>> --00504502b04953b108049503ec60
>> Content-Type: text/plain; charset=ISO-8859-1
>>
>> Hi!
>>
>> I've merged the code for the 340e, that Devin Heitmueller made over at
>> Kernellabs, with the latest HG tree and tested it on Ubuntu 10.10
>> today (2.6.35-22-generic).
>>
>> I lack the knowledge on how to add the new files (xc4000.c and
>> xc4000.h) to a patch, so the script added in the tar ball just copies
>> it to the right place, the firmware has to be manually copied too.
>>
>> /Magnus
>
> Just want to share an alternatives, patches to vanilla kernel 2.6.35;
> by me, which I sent to Istvan Varga.
>
> http://istvanv.users.sourceforge.net/v4l/xc4000.html
>
>
> I am using PCTV 340e with GNU/Linux since Devin Heitmueller's
> "Christmas present" in kernellabs.com last year. I did few portings to
> make the driver workable with vanilla 2.6.34 and later.
>
> Beside's Devin's xc4000.[ch], I also use the files (xc4000.[ch] and
> firmware) from Istvan page. It works very well and the dongle feels
> much cooler when idling. because the PCTV 340e's power management is
> working.
>
> Since there are several devices using xc4000 driver; I really hope
> that it can included in main v4l stream; at least in the staging
> directory.
>
> Also really like to see analog support (S-video capture, analog TV and
> FM radio) for PCTV 340e too :). I was told that the dib0700 driver
> does not has the analog tuning yet.
>
> Thank you
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Tried "your" code today and it works slightly better since the tuner
still works after a reboot.
The remote stops working tho. I get this in dmesg: "dib0700: rc submit
urb failed".

Can't say I notice any difference on how warm it becomes tho.

/Magnus Alm
