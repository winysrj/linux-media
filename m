Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63609 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1LOJyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:54:32 -0500
Received: by yhr47 with SMTP id 47so2053746yhr.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 01:54:31 -0800 (PST)
Message-ID: <4EE9C3D4.3080705@gmail.com>
Date: Thu, 15 Dec 2011 07:54:28 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
CC: Mihai Dobrescu <msdobrescu@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com>
In-Reply-To: <4EE9AA21.1060101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 06:04, Fredrik Lingvall wrote:
> On 12/14/11 17:33, Mihai Dobrescu wrote:
>> Hello,
>>
>> I need to make my tunner working too.
>> Did you make it work?
>> Where did you get the firmware (dvb-usb-hauppauge-hvr930c-drxk.fw)?
>> I have Sabayon 7 64 bit, which is sort of Gentoo, as I've seen you have.
>>
>> Thank you.
> Hi Mihai,
> 
> There is a perl script  get_dvb_firmware that downloads the firmware and extract it (from the Windows driver I think). You need a version of get_dvb_firmware where this has been added:
> 
> +sub drxk_hauppauge_hvr930c {
> +    my $url = "http://www.wintvcd.co.uk/drivers/";
> +    my $zipfile = "HVR-9x0_5_10_325_28153_SIGNED.zip";
> +    my $hash = "83ab82e7e9480ec8bf1ae0155ca63c88";
> +    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
> +    my $drvfile = "HVR-900/emOEM.sys";
> +    my $fwfile = "dvb-usb-hauppauge-hvr930c-drxk.fw";
> +
> +    checkstandard();
> +
> +    wgetfile($zipfile, $url . $zipfile);
> +    verify($zipfile, $hash);
> +    unzip($zipfile, $tmpdir);
> +    extract("$tmpdir/$drvfile", 0x117b0, 42692, "$fwfile");
> +
> +    "$fwfile"
> +}
> +
> 
> Do a git checkout of the linux-media tree to get it (I think).
> 
> Also, before I found the perl script I did it "manually" using:
> 
> 1)
> 
> wget http://www.wintvcd.co.uk/drivers/HVR-9x0_5_10_325_28153_SIGNED.zip
> 
> 2) unzip it
> 
> 3) extact it with dd [0x117b (hex)  =  71600 (dec)]:
> 
> dd if=HVR-900/emOEM.sys of=dvb-usb-hauppauge-hvr930c-drxk.fw bs=1 skip=71600 count=42692

This is basically what the script does, with one difference:
it will double check if the extracted binary blob is really a firmware,
by comparing it with a known hash value. This way, if the driver there gots
updated, the script will fail, instead of writing some random values to a
.fw file.

> 
> 4) copy it to the firmware dir
> 
> cp dvb-usb-hauppauge-hvr930c-drxk.fw /lib/firmware/'

> 
> HTH
> 
> /Fredrik
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

