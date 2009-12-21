Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36260 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZLUCOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 21:14:52 -0500
Received: by ewy19 with SMTP id 19so3529118ewy.1
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 18:14:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B2EFC5E.7040900@gmail.com>
References: <4B2DDE8E.4090708@free.fr> <4B2EFC5E.7040900@gmail.com>
Date: Mon, 21 Dec 2009 15:14:50 +1300
Message-ID: <cd98718e0912201814of2f286bs4199ff9c7387a61f@mail.gmail.com>
Subject: Re: Nova-T 500 Dual DVB-T
From: Carey Stevens <carey@zestgroup.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Yves <ydebx6@free.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

FYI, I had some trouble with this card along the lines of these posts
you might find interesting

http://www.mail-archive.com/linux-media@vger.kernel.org/msg08331.html
http://osdir.com/ml/linux-media/2009-02/msg00948.html

I have the card now working using Ubuntu 9.10 (2.6.31 kernel), with
the manual addition of V4L from a version prior to the patch to use
the new 1.20 firmware..

Carey



2009/12/21 Douglas Schilling Landgraf <dougsland@gmail.com>:
> Hello Yves,
>
> On 12/20/2009 03:21 AM, Yves wrote:
>>
>> Hi,
>>
>> I have a Nova-T 500 Dual DVB-T card that used to work very well under
>> Mandriva 2008.1 (kernel 2.6.24.7).
>>
>> I moved to Mandriva 2009.1, then 2010.0 (kernel 2.6.31.6) and it doesn't
>> work well any more. Scan can't find channels. I tried hading "options
>> dvb-usb-dib0700 force_lna_activation=1" in /etc/modprobe.conf. It improve
>> just a bit. Scan find only a few channels. If I revert to Mandriva 2008.1
>> (in another partition), all things are good (without adding anything in
>> modprobe.conf).
>>
>> Is there a new version of the driver (dvb_usb_dib0700) that correct this
>> behavior.
>> If not, how to install the driver from kernel 2.6.24.7 in kernel 2.6.31.6
>> ?
>>
>
> Please try the current driver available at v4l/dvb develpment tree and share
> your results here.
>
> hg clone http://linuxtv.org/hg/v4l-dvb
> make
> make rmmod
> make install
>
> Finally, just restart your machine and test your favourite application.
>
> For additional info:
>
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>
> Cheers,
> Douglas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
