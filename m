Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37793 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754879AbcJTKqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Oct 2016 06:46:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Fitch <kfitch42@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH v2 54/58] i2c: don't break long lines
Date: Thu, 20 Oct 2016 13:46:08 +0300
Message-ID: <4116505.KJG2renCst@avalon>
In-Reply-To: <33d775f4e173dd72f82c190bfd2e542749a5481c.1476822925.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com> <33d775f4e173dd72f82c190bfd2e542749a5481c.1476822925.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Tuesday 18 Oct 2016 18:46:06 Mauro Carvalho Chehab wrote:
> Due to the 80-cols restrictions, and latter due to checkpatch
> warnings, several strings were broken into multiple lines. This
> is not considered a good practice anymore, as it makes harder
> to grep for strings at the source code.
> 
> As we're right now fixing other drivers due to KERN_CONT, we need
> to be able to identify what printk strings don't end with a "\n".
> It is a way easier to detect those if we don't break long lines.
> 
> So, join those continuation lines.
> 
> The patch was generated via the script below, and manually
> adjusted if needed.
> 
> </script>
> use Text::Tabs;
> while (<>) {
> 	if ($next ne "") {
> 		$c=$_;
> 		if ($c =~ /^\s+\"(.*)/) {
> 			$c2=$1;
> 			$next =~ s/\"\n$//;
> 			$n = expand($next);
> 			$funpos = index($n, '(');
> 			$pos = index($c2, '",');
> 			if ($funpos && $pos > 0) {
> 				$s1 = substr $c2, 0, $pos + 2;
> 				$s2 = ' ' x ($funpos + 1) . substr $c2, 
$pos + 2;
> 				$s2 =~ s/^\s+//;
> 
> 				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne 
"");
> 
> 				print unexpand("$next$s1\n");
> 				print unexpand("$s2\n") if ($s2 ne "");
> 			} else {
> 				print "$next$c2\n";
> 			}
> 			$next="";
> 			next;
> 		} else {
> 			print $next;
> 		}
> 		$next="";
> 	} else {
> 		if (m/\"$/) {
> 			if (!m/\\n\"$/) {
> 				$next=$_;
> 				next;
> 			}
> 		}
> 	}
> 	print $_;
> }
> </script>
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/as3645a.c          | 13 +++++++------
>  drivers/media/i2c/msp3400-kthreads.c |  4 ++--
>  drivers/media/i2c/mt9m032.c          |  5 +++--
>  drivers/media/i2c/mt9p031.c          |  5 +++--
>  drivers/media/i2c/saa7115.c          | 18 +++++++++++-------
>  drivers/media/i2c/saa717x.c          |  4 ++--
>  drivers/media/i2c/tvp5150.c          | 14 ++++++++------
>  drivers/media/i2c/tvp7002.c          |  6 +++---
>  drivers/media/i2c/upd64083.c         |  4 +---
>  9 files changed, 40 insertions(+), 33 deletions(-)

[snip]

> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index 58062b41c923..3b341a9da004 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c

[snip]


> @@ -1538,8 +1537,10 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
> /* status for the saa7114 */
>  		reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
>  		signalOk = (reg1f & 0xc1) == 0x81;
> -		v4l2_info(sd, "Video signal:    %s\n", signalOk ? "ok" : 
"bad");

No need to change this one, if fits on a single line.

> -		v4l2_info(sd, "Frequency:       %s\n", (reg1f & 0x20) ? "60 
Hz" : "50
> Hz"); +		v4l2_info(sd, "Video signal:    %s\n",
> +			  signalOk ? "ok" : "bad");
> +		v4l2_info(sd, "Frequency:       %s\n",
> +			  (reg1f & 0x20) ? "60 Hz" : "50 Hz");
>  		return 0;
>  	}
> 

[snip]

> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 4740da39d698..b3a9580ef1e4 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -280,10 +280,10 @@ static inline void tvp5150_selmux(struct v4l2_subdev
> *sd) break;
>  	}
> 
> -	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i, 
output=%i "
> -			"=> tvp5150 input=%i, opmode=%i\n",
> -			decoder->input, decoder->output,
> -			input, opmode);
> +	v4l2_dbg(1, debug, sd,
> +		 "Selecting video route: route input=%i, output=%i => 
tvp5150 input=%i, opmode=%i\n",
> +		 decoder->input, decoder->output,
> +		 input, opmode);

The three arguments can fit on a single line.

> 
>  	tvp5150_write(sd, TVP5150_OP_MODE_CTL, opmode);
>  	tvp5150_write(sd, TVP5150_VD_IN_SRC_SEL_1, input);
> @@ -649,7 +649,8 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
>  	int pos=0;
> 
>  	if (std == V4L2_STD_ALL) {
> -		v4l2_err(sd, "VBI can't be configured without knowing number 
of
> lines\n");
> +		v4l2_err(sd,
> +			 "VBI can't be configured without knowing number of 
lines\n");

I'm quite doubtful that this particular change improves readability :-)

>  		return 0;
>  	} else if (std & V4L2_STD_625_50) {
>  		/* Don't follow NTSC Line number convension */
> @@ -697,7 +698,8 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
>  	int i, ret = 0;
> 
>  	if (std == V4L2_STD_ALL) {
> -		v4l2_err(sd, "VBI can't be configured without knowing number 
of
> lines\n");
> +		v4l2_err(sd,
> +			 "VBI can't be configured without knowing number of 
lines\n");

Ditto.

>  		return 0;
>  	} else if (std & V4L2_STD_625_50) {
>  		/* Don't follow NTSC Line number convension */

[snip]

-- 
Regards,

Laurent Pinchart

