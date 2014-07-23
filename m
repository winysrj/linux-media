Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57960 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbaGWJUx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:20:53 -0400
Message-ID: <53CF7E6D.20406@iki.fi>
Date: Wed, 23 Jul 2014 12:20:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org> <1406059938-21141-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1406059938-21141-2-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Matthias

On 07/22/2014 11:12 PM, Matthias Schwarzott wrote:
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   Documentation/dvb/get_dvb_firmware | 33 ++++++++++++++++++++++++++++++++-
>   1 file changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
> index d91b8be..26c623d 100755
> --- a/Documentation/dvb/get_dvb_firmware
> +++ b/Documentation/dvb/get_dvb_firmware
> @@ -29,7 +29,7 @@ use IO::Handle;
>   		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
>   		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
>   		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "drxk_pctv",
> -		"drxk_terratec_htc_stick", "sms1xxx_hcw");
> +		"drxk_terratec_htc_stick", "sms1xxx_hcw", "si2165");
>
>   # Check args
>   syntax() if (scalar(@ARGV) != 1);
> @@ -783,6 +783,37 @@ sub sms1xxx_hcw {
>       $allfiles;
>   }
>
> +sub si2165 {
> +    my $sourcefile = "model_111xxx_122xxx_driver_6_0_119_31191_WHQL.zip";
> +    my $url = "http://www.hauppauge.de/files/drivers/";
> +    my $hash = "76633e7c76b0edee47c3ba18ded99336";
> +    my $fwfile = "dvb-demod-si2165.fw";
> +    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
> +
> +    checkstandard();
> +
> +    wgetfile($sourcefile, $url . $sourcefile);
> +    verify($sourcefile, $hash);
> +    unzip($sourcefile, $tmpdir);
> +    extract("$tmpdir/Driver10/Hcw10bda.sys", 0x80788, 0x81E08-0x80788, "$tmpdir/fw1");
> +
> +    delzero("$tmpdir/fw1","$tmpdir/fw1-1");
> +    #verify("$tmpdir/fw1","5e0909858fdf0b5b09ad48b9fe622e70");
> +
> +    my $CRC="\x0A\xCC";
> +    my $BLOCKS_MAIN="\x27";
> +    open FW,">$fwfile";
> +    print FW "\x01\x00"; # just a version id for the driver itself
> +    print FW "\x9A"; # fw version
> +    print FW "\x00"; # padding
> +    print FW "$BLOCKS_MAIN"; # number of blocks of main part
> +    print FW "\x00"; # padding
> +    print FW "$CRC"; # 16bit crc value of main part
> +    appendfile(FW,"$tmpdir/fw1");

I have to say I little bit dislike that kind of own headers. There is no 
way to read firmware version from binary itself (very often there is)? 
Whats is benefit of telling how many blocks there is? Isn't it possible 
to detect somehow by examining firmware image itself runtime?

Anyhow, you are the author of that driver and even I don't personally 
like those, I think it is up to your decision as a author.

regards
Antti


> +
> +    "$fwfile";
> +}
> +
>   # ---------------------------------------------------------------
>   # Utilities
>
>

-- 
http://palosaari.fi/
