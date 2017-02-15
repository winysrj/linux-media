Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52795 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdBOPOx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 10:14:53 -0500
Date: Wed, 15 Feb 2017 15:14:50 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [regression] dvb_usb_cxusb (was Re: ir-keytable: infinite loops,
 segfaults)
Message-ID: <20170215151450.GA5781@gofer.mess.org>
References: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 08, 2017 at 10:30:30PM +1100, Vincent McIntyre wrote:
> Hi
> 
> I have been working with Sean on figuring out the protocol used by a
> dvico remote.
> I thought the patch he sent was at fault but I backed it out and tried again.
> 
> I've attached a full dmesg but the core of it is when dvb_usb_cxusb
> tries to load:
> 
> [    7.858907] WARNING: You are using an experimental version of the
> media stack.
>                 As the driver is backported to an older kernel, it doesn't offer
>                 enough quality for its usage in production.
>                 Use it with care.
>                Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
>                 47b037a0512d9f8675ec2693bed46c8ea6a884ab [media]
> v4l2-async: failing functions shouldn't have side effects
>                 79a2eda80c6dab79790c308d9f50ecd2e5021ba3 [media]
> mantis_dvb: fix some error codes in mantis_dvb_init()
>                 c2987aaf0c9c2bcb0d4c5902d61473d9aa018a3d [media]
> exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT
> [    7.861968] dvb_usb_af9035 1-4:1.0: prechip_version=83
> chip_version=02 chip_type=9135
> [    7.887476] dvb_usb_cxusb: disagrees about version of symbol

Sorry about not getting back to you sooner, life got in the way. The
problem here is that the dvb-usb-cxusb did not get selected, so it
was not recompiled.

The problem is that DVB_USB_CXUSB Kconfig has this line:
        select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
The make_kconfig.pl script transforms this into a dependency, but 
DVB_SI2168 is only available when compiling against kernel 4.7 or later. 
I think only one select line needs to match, so I created this patch.

Please apply this patch against media_build, you might need to do make
clean before building again.

Thanks,

Sean


From: Sean Young <sean@mess.org>
Date: Wed, 15 Feb 2017 14:58:00 +0000
Subject: [PATCH] only one select Kconfig needs to match

---
 v4l/scripts/make_kconfig.pl | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/v4l/scripts/make_kconfig.pl b/v4l/scripts/make_kconfig.pl
index ba8c134..a11f820 100755
--- a/v4l/scripts/make_kconfig.pl
+++ b/v4l/scripts/make_kconfig.pl
@@ -169,6 +169,7 @@ sub depends($$)
 	push @{$depends{$key}}, $deps;
 }
 
+my %selectdepends = ();
 sub selects($$$)
 {
 	my $key = shift;
@@ -181,7 +182,7 @@ sub selects($$$)
 		# Transform "select X if Y" into "depends on !Y || X"
 		$select = "!($if) || ($select)";
 	}
-	push @{$depends{$key}}, $select;
+	push @{$selectdepends{$key}}, $select;
 }
 
 # Needs:
@@ -228,6 +229,23 @@ sub checkdeps()
 				return 0;
 			}
 		}
+		my $selectdeps = $selectdepends{$key};
+		if ($selectdeps) {
+			my $found = 0;
+			foreach (@$selectdeps) {
+				next if($_ eq '');
+				if (eval(toperl($_))) {
+					$found = 1;
+					last;
+				}
+			}
+			if ($found == 0) {
+				print "Disabling $key, select dependency '$_' not met\n" if $debug;
+				$allconfig{$key} = 0;
+				return 0;
+			}
+		}
+
 		return 1;
 	}
 
-- 
2.7.4
