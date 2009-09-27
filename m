Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:38079 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZI0Qe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 12:34:57 -0400
Received: by ewy7 with SMTP id 7so3805784ewy.17
        for <linux-media@vger.kernel.org>; Sun, 27 Sep 2009 09:35:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840909270925y5de5f10fn1a10e63d62953fe0@mail.gmail.com>
References: <20090922210500.GA8661@systol-ng.god.lan>
	 <37219a840909241146q72af5395hc028b91b6a97ada1@mail.gmail.com>
	 <20090924214233.GA13708@systol-ng.god.lan>
	 <37219a840909270925y5de5f10fn1a10e63d62953fe0@mail.gmail.com>
Date: Sun, 27 Sep 2009 12:35:00 -0400
Message-ID: <37219a840909270935j74a25f3fn229839fb7c2cf50a@mail.gmail.com>
Subject: Re: [PATCH 1/4] tda18271_set_analog_params major bugfix
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 27, 2009 at 12:25 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> On Thu, Sep 24, 2009 at 5:42 PM,  <spam@systol-ng.god.lan> wrote:
>> On Thu, Sep 24, 2009 at 02:46:06PM -0400, Michael Krufky wrote:
>>> On Tue, Sep 22, 2009 at 5:05 PM,  <spam@systol-ng.god.lan> wrote:
>>> >
>>> > Multiplication by 62500 causes an overflow in the 32 bits "freq" register when
>>> > using radio. FM radio reception on a Zolid Hybrid PCI is now working. Other
>>> > tda18271 configurations may also benefit from this change ;)
>>> >
>>> > Signed-off-by: Henk.Vergonet@gmail.com
>>> >
>>> > diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-fe.c
>> ...
>>> > -               freq = freq / 1000;
>>> > +               freq = params->frequency * 625;
>>> > +               freq = freq / 10;
>>
>> Hmm now that I review my own patch:
>>
>> -               freq = freq / 1000;
>> +               freq = params->frequency * 125;
>> +               freq = freq / 2;
>>
>> might even be better...
>
> Henk,
>
> That certainly is better, but I am going to go with an even simpler &
> cleaner approach:
>
> diff -r f52640ced9e8 linux/drivers/media/common/tuners/tda18271-fe.c
> --- a/linux/drivers/media/common/tuners/tda18271-fe.c   Tue Sep 15
> 01:25:35 2009 -0400
> +++ b/linux/drivers/media/common/tuners/tda18271-fe.c   Sun Sep 27
> 12:21:37 2009 -0400
> @@ -1001,12 +1001,12 @@
>        struct tda18271_std_map_item *map;
>        char *mode;
>        int ret;
> -       u32 freq = params->frequency * 62500;
> +       u32 freq = params->frequency *
> +               ((params->mode == V4L2_TUNER_RADIO) ? 125 / 2 : 62500);
>
>        priv->mode = TDA18271_ANALOG;
>
>        if (params->mode == V4L2_TUNER_RADIO) {
> -               freq = freq / 1000;
>                map = &std_map->fm_radio;
>                mode = "fm";
>        } else if (params->std & V4L2_STD_MN) {
>
>
> You still get the credit for spotting the problem & providing the
> original fix -- thanks again!  I'm going to push this along with the
> others today.

On a second thought, I see that my above patch loses some precision
...  this is even better:

diff -r f52640ced9e8 linux/drivers/media/common/tuners/tda18271-fe.c
--- a/linux/drivers/media/common/tuners/tda18271-fe.c	Tue Sep 15
01:25:35 2009 -0400
+++ b/linux/drivers/media/common/tuners/tda18271-fe.c	Sun Sep 27
12:33:20 2009 -0400
@@ -1001,12 +1001,12 @@
 	struct tda18271_std_map_item *map;
 	char *mode;
 	int ret;
-	u32 freq = params->frequency * 62500;
+	u32 freq = params->frequency * 125 *
+		((params->mode == V4L2_TUNER_RADIO) ? 1 : 1000) / 2;

 	priv->mode = TDA18271_ANALOG;

 	if (params->mode == V4L2_TUNER_RADIO) {
-		freq = freq / 1000;
 		map = &std_map->fm_radio;
 		mode = "fm";
 	} else if (params->std & V4L2_STD_MN) {

Cheers,

Mike
