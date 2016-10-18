Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy004.phy.lolipop.jp ([157.7.104.45]:41778 "EHLO
        smtp-proxy004.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750770AbcJRXDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 19:03:10 -0400
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1476822924.git.mchehab@s-opensource.com>
 <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Message-ID: <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
Date: Wed, 19 Oct 2016 08:03:01 +0900
MIME-Version: 1.0
In-Reply-To: <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Oct 19 2016 05:46, Mauro Carvalho Chehab wrote:
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
> 				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
> 				$s2 =~ s/^\s+//;
> 
> 				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");
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
> Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/firewire/firedtv-rc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-rc.c b/drivers/media/firewire/firedtv-rc.c
> index f82d4a93feb3..46dde73944df 100644
> --- a/drivers/media/firewire/firedtv-rc.c
> +++ b/drivers/media/firewire/firedtv-rc.c
> @@ -184,8 +184,8 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
>  	else if (code >= 0x4540 && code <= 0x4542)
>  		code = oldtable[code - 0x4521];
>  	else {
> -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> -		       "from remote control\n", code);
> +		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x from remote control\n",
> +		       code);
>  		return;
>  	}

I realized that we can use dev_dbg() instead of the printk(). What do
you think about this patch? Anyway, the line is within 80 characters.

-------- 8< --------

>From da3289a04226450d6dbabb5c81155ac17c11374d Mon Sep 17 00:00:00 2001
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Date: Wed, 19 Oct 2016 07:53:35 +0900
Subject: [PATCH] [media] firewire: use dev_dbg() instead of printk()

A structure for firedtv (struct firedtv) has a member for a pointer to
struct device. In this case, we can use dev_dbg() for debug printing.
This is more preferrable behaviour in device driver development.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 drivers/media/firewire/firedtv-rc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/firewire/firedtv-rc.c
b/drivers/media/firewire/firedtv-rc.c
index f82d4a9..04dea2a 100644
--- a/drivers/media/firewire/firedtv-rc.c
+++ b/drivers/media/firewire/firedtv-rc.c
@@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned
int code)
 	else if (code >= 0x4540 && code <= 0x4542)
 		code = oldtable[code - 0x4521];
 	else {
-		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
-		       "from remote control\n", code);
+		dev_dbg(fdtv->device,
+			"invalid key code 0x%04x from remote control\n",
+			code);
 		return;
 	}

-- 
2.7.4


Regards

Takashi Sakamoto
