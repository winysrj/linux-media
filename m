Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46493
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943175AbcJSO6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:58:40 -0400
Date: Wed, 19 Oct 2016 08:10:13 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
Message-ID: <20161019081013.641450f4@vento.lan>
In-Reply-To: <20161019100113.077e60f1@kant>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
        <20161019100113.077e60f1@kant>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 10:01:13 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> escreveu:

> On Oct 18 Mauro Carvalho Chehab wrote:
> [...]
> > The patch was generated via the script below, and manually
> > adjusted if needed.  
> [...]
> > Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> > Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/firewire/firedtv-rc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)  
> [...]
> 
> Patch v1 also had a hunk in drivers/media/firewire/firedtv-avc.c.
> What happened to it?

There was some mistake when I manipulated it manually, after re-run
the script.

Btw, I liked more the Takashi's dev_dbg() patch for firedtv-rc.c.

So, I guess the better would be to apply his patch and the one
enclosed here, with just the firedtv-avc.c change.

Thanks,
Mauro

[PATCH] firewire: don't break long lines

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
index 251a556112a9..5bde6c209cd7 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1181,8 +1181,8 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		if (es_info_length > 0) {
 			pmt_cmd_id = msg[read_pos++];
 			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
-				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
-					"at stream level\n", pmt_cmd_id);
+				dev_err(fdtv->device, "invalid pmt_cmd_id %d at stream level\n",
+					pmt_cmd_id);
 
 			if (es_info_length > sizeof(c->operand) - 4 -
 					     write_pos) {
