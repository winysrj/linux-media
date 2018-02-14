Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44206 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161403AbeBNRxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 12:53:21 -0500
Date: Wed, 14 Feb 2018 15:53:14 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "chris\@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
Subject: Re: [PATCH v4 16/18] scripts: kernel-doc: improve nested logic to
 handle multiple identifiers
Message-ID: <20180214155314.1be00577@vento.lan>
In-Reply-To: <874lmjlfmg.fsf@intel.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
        <b89b7c5400afd8c03d88ccccd2b5edd3625a1997.1513599193.git.mchehab@s-opensource.com>
        <874lmjlfmg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Feb 2018 18:07:03 +0200
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Mon, 18 Dec 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > It is possible to use nested structs like:
> >
> > struct {
> > 	struct {
> > 		void *arg1;
> > 	} st1, st2, *st3, st4;
> > };
> >
> > Handling it requires to split each parameter. Change the logic
> > to allow such definitions.
> >
> > In order to test the new nested logic, the following file
> > was used to test  
> 
> Hi Mauro, resurrecting an old thread...
> 
> So this was a great improvement to documenting nested structs. However,
> it looks like it only supports describing the nested structs at the top
> level comment, and fails for inline documentation comments.

True. I didn't consider inline comments when I wrote the patch.
We don't use inline doc tags at media. IMO, a single description block
on the top works better, but yeah, it would be very good if it would
support nested structs to also have inlined comments.

Yet, on a quick hack:

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index fee8952037b1..e2d5cadd8d0b 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1009,6 +1009,8 @@ sub dump_struct($$) {
 	$declaration_name = $2;
 	my $members = $3;
 
+print "members: $members\n";
+
 	# ignore members marked private:
 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
 	$members =~ s/\/\*\s*private:.*//gosi;

produce:

	$ scripts/kernel-doc -none drivers/gpu/drm/i915/intel_dpio_phy.c
	members:  bool dual_channel; enum dpio_phy rcomp_phy; int reset_delay; u32 pwron_mask; struct { enum port port; }  channel[2]; 
	drivers/gpu/drm/i915/intel_dpio_phy.c:154: warning: Function parameter or member 'channel.port' not described in 'bxt_ddi_phy_info'

So, dump_struct() already receives the struct sanitizes without any comments
inside.

There is a simple fix, though. Make inline comments to accept a dot:

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index fee8952037b1..06d7f3f2c094 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -363,7 +363,7 @@ my $doc_sect = $doc_com .
 my $doc_content = $doc_com_body . '(.*)';
 my $doc_block = $doc_com . 'DOC:\s*(.*)?';
 my $doc_inline_start = '^\s*/\*\*\s*$';
-my $doc_inline_sect = '\s*\*\s*(@[\w\s]+):(.*)';
+my $doc_inline_sect = '\s*\*\s*(@\s*[\w][\w\.]*\s*):(.*)';
 my $doc_inline_end = '^\s*\*/\s*$';
 my $doc_inline_oneline = '^\s*/\*\*\s*(@[\w\s]+):\s*(.*)\s*\*/\s*$';
 my $export_symbol = '^\s*EXPORT_SYMBOL(_GPL)?\s*\(\s*(\w+)\s*\)\s*;';

That requires a small change at the inline parameters, though:

diff --git a/drivers/gpu/drm/i915/intel_dpio_phy.c b/drivers/gpu/drm/i915/intel_dpio_phy.c
index 76473e9836c6..c8e9e44e5981 100644
--- a/drivers/gpu/drm/i915/intel_dpio_phy.c
+++ b/drivers/gpu/drm/i915/intel_dpio_phy.c
@@ -147,7 +147,7 @@ struct bxt_ddi_phy_info {
 	 */
 	struct {
 		/**
-		 * @port: which port maps to this channel.
+		 * @channel.port: which port maps to this channel.
 		 */
 		enum port port;
 	} channel[2];

The alternative would be a way more complex: to teach the code with
starts at:

	If ($inline_doc_state == STATE_INLINE_NAME && /$doc_inline_sect/o) {

About how to handle with inlined structs/enums at inlined comments.

Thanks,
Mauro
