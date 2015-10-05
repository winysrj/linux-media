Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47316 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbJEMDz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 08:03:55 -0400
Date: Mon, 5 Oct 2015 09:03:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: How to fix DocBook parsers for private fields inside #ifdefs
Message-ID: <20151005090348.7937fa4a@recife.lan>
In-Reply-To: <20151005045635.455b20eb@lwn.net>
References: <20151001142107.5a0bf7b2@recife.lan>
	<20151005045635.455b20eb@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Oct 2015 04:56:35 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 1 Oct 2015 14:21:07 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > They're all after a private comment:
> > 	/* Private: internal use only */
> > 
> > So, according with Documentation/kernel-doc-nano-HOWTO.txt, they shold
> > have been ignored.
> > 
> > Still, the scripts produce warnings for them:
> 
> Sorry, I've been away from the keyboard for a few days and am only now
> catching up.
> 
> The problem is that kernel-doc is dumb...the test is case-sensitive, so
> it needs to be "private:", not "Private:".  I'm sure there's a magic perl
> regex parameter to make the test case-insensitive; when I get a chance
> I'll figure it out and put it in there.

Ah, that makes sense. Adding an "i" to the end of the regex expression
should make it case-insensitive:

-       $members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gos;
-       $members =~ s/\/\*\s*private:.*//gos;
+       $members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
+       $members =~ s/\/\*\s*private:.*//gosi;

Patch enclosed. Yet, I guess nobody would try to use PRIVATE: So, 
another alternative would be to do, instead:

-	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gos;
-	$members =~ s/\/\*\s*private:.*//gos;
+	$members =~ s/\/\*\s*[Pp]rivate:.*?\/\*\s*public:.*?\*\///gos;
+	$members =~ s/\/\*\s*[Pp]rivate:.*//gos;

Whatever works best for you.

> (Of course, once you fix that glitch, you'll get gripes about the fields
> that are marked private but documented anyway.  Like I said, kernel-doc
> is dumb.)

Yeah, now I'm getting those warnings:

.//include/media/videobuf2-core.h:254: warning: Excess struct/union/enum/typedef member 'state' description in 'vb2_buffer'
.//include/media/videobuf2-core.h:254: warning: Excess struct/union/enum/typedef member 'queued_entry' description in 'vb2_buffer'
.//include/media/videobuf2-core.h:254: warning: Excess struct/union/enum/typedef member 'done_entry' description in 'vb2_buffer'

I'll fix that.

-

DocBook: Fix kernel-doc to be case-insensitive for private:

On some places, people could use Private: to tag the private fields
of an struct. So, be case-insensitive when parsing "private:"
meta-tag.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9a08fb5c1af6..702c6ac1350e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1791,8 +1791,8 @@ sub dump_struct($$) {
 	$nested = $1;
 
 	# ignore members marked private:
-	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gos;
-	$members =~ s/\/\*\s*private:.*//gos;
+	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
+	$members =~ s/\/\*\s*private:.*//gosi;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;

