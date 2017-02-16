Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35439 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754300AbdBPNJI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 08:09:08 -0500
Received: by mail-wr0-f193.google.com with SMTP id q39so1991269wrb.2
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 05:09:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEsFdVNXCO4n8tMVpKsYme1K1qH1Nm0zAwCFJgS8sfuCiTHbhw@mail.gmail.com>
References: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
 <20170215151450.GA5781@gofer.mess.org> <CAEsFdVNXCO4n8tMVpKsYme1K1qH1Nm0zAwCFJgS8sfuCiTHbhw@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Fri, 17 Feb 2017 00:09:06 +1100
Message-ID: <CAEsFdVOb9xDurk95nmGzCPVgKJHwX2PEfNonNVOXqsz3G34Gcg@mail.gmail.com>
Subject: Fwd: [regression] dvb_usb_cxusb (was Re: ir-keytable: infinite loops, segfaults)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list

I missed you in the cc: field...

---------- Forwarded message ----------
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Thu, 16 Feb 2017 23:51:05 +1100
Subject: Re: [regression] dvb_usb_cxusb (was Re: ir-keytable: infinite
loops, segfaults)
To: Sean Young <sean@mess.org>

On 2/16/17, Sean Young <sean@mess.org> wrote:
>
> The problem is that DVB_USB_CXUSB Kconfig has this line:
>         select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
> The make_kconfig.pl script transforms this into a dependency, but
> DVB_SI2168 is only available when compiling against kernel 4.7 or later.
> I think only one select line needs to match, so I created this patch.
>
> Please apply this patch against media_build, you might need to do make
> clean before building again.

Awsome - build is working again, thank you. See the other thread for
my progress report.

> Thanks,
>
> Sean
>
>
> From: Sean Young <sean@mess.org>
> Date: Wed, 15 Feb 2017 14:58:00 +0000
> Subject: [PATCH] only one select Kconfig needs to match

Tested-by: vincent.mcintyre@gmail.com

> ---
>  v4l/scripts/make_kconfig.pl | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/v4l/scripts/make_kconfig.pl b/v4l/scripts/make_kconfig.pl
> index ba8c134..a11f820 100755
> --- a/v4l/scripts/make_kconfig.pl
> +++ b/v4l/scripts/make_kconfig.pl
> @@ -169,6 +169,7 @@ sub depends($$)
>  	push @{$depends{$key}}, $deps;
>  }
>
> +my %selectdepends = ();
>  sub selects($$$)
>  {
>  	my $key = shift;
> @@ -181,7 +182,7 @@ sub selects($$$)
>  		# Transform "select X if Y" into "depends on !Y || X"
>  		$select = "!($if) || ($select)";
>  	}
> -	push @{$depends{$key}}, $select;
> +	push @{$selectdepends{$key}}, $select;
>  }
>
>  # Needs:
> @@ -228,6 +229,23 @@ sub checkdeps()
>  				return 0;
>  			}
>  		}
> +		my $selectdeps = $selectdepends{$key};
> +		if ($selectdeps) {
> +			my $found = 0;
> +			foreach (@$selectdeps) {
> +				next if($_ eq '');
> +				if (eval(toperl($_))) {
> +					$found = 1;
> +					last;
> +				}
> +			}
> +			if ($found == 0) {
> +				print "Disabling $key, select dependency '$_' not met\n" if $debug;
> +				$allconfig{$key} = 0;
> +				return 0;
> +			}
> +		}
> +
>  		return 1;
>  	}
>
> --
> 2.7.4

Vince
