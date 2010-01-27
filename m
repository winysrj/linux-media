Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51245 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab0A0TDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 14:03:37 -0500
Received: by ewy19 with SMTP id 19so791778ewy.21
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 11:03:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100127193728.0a75ba1e@tele>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br>
	 <20100126193726.00bcbc00@tele>
	 <20100127163709.GA10435@pathfinder.pcs.usp.br>
	 <20100127171753.GA10865@pathfinder.pcs.usp.br>
	 <20100127193728.0a75ba1e@tele>
Date: Wed, 27 Jan 2010 16:03:35 -0300
Message-ID: <c2fe070d1001271103g27c44093u48be6a60ae28323f@mail.gmail.com>
Subject: Re: Setting up white balance on a t613 camera
From: leandro Costantino <lcostantino@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, as wrote in the code, it tied to whitebalance.
Also note that , as Jean wrote, there's are many different values
wrote on some registers, that we don't really know what they are used
for, so,
i would like to go for the most non intrusive option, since, some of
this whitebalance regs, have been adjusted time to time to meet other
t613 users requirment's, and maybe implementing the r/b balance would
be the way to go.

If you want, i can write it so you can test it, or if you prefeer you
can take a look at
http://linuxtv.org/hg/~jfrancois/gspca/file/21f2eeb240db/linux/drivers/media/video/gspca/sonixj.c
at how its done  as an example.

Since i only had this webcam for 1 week, i always relay on the some
group of users that are willing to test each change always.

Best Regadrs.
Costantino Leandro

On Wed, Jan 27, 2010 at 3:37 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Wed, 27 Jan 2010 15:17:53 -0200
> Nicolau Werneck <nwerneck@gmail.com> wrote:
>
>> Answering my own question, and also a question in the t613 source
>> code...
>>
>> Yes, the need for the "reg_w(gspca_dev, 0x2087);", 0x2088 and 0x2089
>> commands are definitely tied to the white balance. These three set up
>> the default values I found out. And (X << 8 + 87) sets up the red
>> channel parameter in general, and 88 is for green and 89 for blue.
>>
>> That means I can already just play with them and see what happens. My
>> personal problem is that I bought this new lens, and the image is way
>> too bright, and changing that seems to help. But I would like to offer
>> these as parameters the user can set using v4l2 programs. I can try
>> making that big change myself, but help from a more experienced
>> developer would be certainly much appreciated!...
>
> Hello Nicolau,
>
> The white balance is set in setwhitebalance(). Four registers are
> changed: 87, 88, 89 and 80.
>
> Looking at the traces I have, these 4 registers are loaded together only
> one time in an exchange at startup time. Then, the white balance
> control adjusts only blue and red values while reloading the same value
> for the green register (that's what is done for other webcams), and the
> register 80 is not touched. In the different traces, the register 80
> may be initialized to various values as 3c, ac or 38 and it is not
> touched later. I do not know what it is used for.
>
> I may also notice that the green value in the white balance exchanges
> may have an other value than the default 20. I do not know which is the
> associated control in the ms-win driver. If it is exposure, you are
> done. So, one trivial patch is:
>
> - add the exposure control with min: 0x10, max: 0x40, def: 0x20.
>
> - modify the whitebalance control with min: -16, max +16, def:0.
>
> - there is no function setexposure() because the exposure is the value
>  of green register. Both controls exposure and white balance call the
>  function setwhitebalance().
>
> - in the function setwhitebalance(), set the green value to the
>  exposure, the red value to (exposure + whitebalance) and blue value
>  to (exposure - whitebalance) and load only the registers 87, 88 and
>  89.
>
> An other way could be to implement the blue and red balances in the
> same scheme, and to remove the whitebalance.
>
> Cheers.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
