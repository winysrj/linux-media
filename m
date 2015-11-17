Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57952 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbKQP35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 10:29:57 -0500
Date: Tue, 17 Nov 2015 13:29:49 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	LMML <linux-media@vger.kernel.org>, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 2/4] scripts/kernel-doc: Replacing highlights hash by
 an array
Message-ID: <20151117132949.2c70d92f@recife.lan>
In-Reply-To: <20151117074431.01338392@lwn.net>
References: <1438112718-12168-1-git-send-email-danilo.cesar@collabora.co.uk>
	<1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
	<20151117084046.5c911c6a@recife.lan>
	<20151117074431.01338392@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Nov 2015 07:44:31 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 17 Nov 2015 08:40:46 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > The above causes some versions of perl to fail, as keys expect a
> > hash argument:
> > 
> > Execution of .//scripts/kernel-doc aborted due to compilation errors.
> > Type of arg 1 to keys must be hash (not private array) at .//scripts/kernel-doc line 2714, near "@highlights) "
> > 
> > This is happening at linuxtv.org server, with runs perl version 5.10.1.
> 
> OK, that's not good.  But I'm not quite sure what to do about it.
> 
> Perl 5.10.1 is a little over six years old.  Nobody else has complained
> (yet) about this problem.  So it might be best to "fix" this with a
> minimum version added to the Changes file.
> 
> Or maybe we need to revert the patch.
> 
> So I'm far from a Perl expert, so I have no clue what the minimum version
> would be if we were to say "5.10.1 is too old."  I don't suppose anybody
> out there knows?

I'm also not a Perl expert, and never saw before the usage of "keys" on
an array. Yet, according with:
	http://perldoc.perl.org/functions/keys.html

"in Perl 5.12 or later only, the indices of an array"

If so, then maybe we could replace:
	foreach my $k (keys @highlights)

by a more C style variant, with all versions of perl 5:
	for (my $k = 0; $k < @highlights; $k++) {

The enclosed patch should do the trick. I tested it with perl 5.10 and 
perl 5.22 it worked fine with both versions.

Regards,
Mauro

-

kernel-doc: Make it compatible with Perl versions below 5.12 again

Changeset 4d73270192ec('scripts/kernel-doc: Replacing highlights
hash by an array') broke compatibility of the kernel-doc script with
older versions of perl by using "keys ARRAY" syntax with is available
only on Perl 5.12 or newer, according with:
	http://perldoc.perl.org/functions/keys.html

Restore backward compatibility by replacing "foreach my $k (keys ARRAY)"
by a C-like variant: "for (my $k = 0; $k < !ARRAY; $k++)"

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 125b906..1f61def 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2711,7 +2711,7 @@ $kernelversion = get_kernel_version();
 
 # generate a sequence of code that will splice in highlighting information
 # using the s// operator.
-foreach my $k (keys @highlights) {
+for (my $k = 0; $k < @highlights; $k++) {
     my $pattern = $highlights[$k][0];
     my $result = $highlights[$k][1];
 #   print STDERR "scanning pattern:$pattern, highlight:($result)\n";
