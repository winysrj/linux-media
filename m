Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1HAAq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 20:46:56 -0400
Message-ID: <4E35F779.4090100@redhat.com>
Date: Sun, 31 Jul 2011 21:46:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Henning Hollermann <henning.hollermann@stud.uni-goettingen.de>
CC: linux-media@vger.kernel.org
Subject: Re: Missing package "Proc::ProcessTable" is in debian: libproc-processtable-perl
References: <4E35DECA.2090700@stud.uni-goettingen.de>
In-Reply-To: <4E35DECA.2090700@stud.uni-goettingen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Henning,

Em 31-07-2011 20:01, Henning Hollermann escreveu:
> I just tried to install the latest media-build-package via git. I got an
> error because of a missing package, but the script could not provide a
> hint about the name of the missing package. One quick search made clear,
> that it was perl's ProcessTable package, which was missing. This is
> named "libproc-processtable-perl" in debian, so you could add this as hint.

There are some functions there that tries to detect the distribution used.
Currently, it parses Fedora, RHEL and Ubuntu. From the above, it seems
that the requirements for Debian are the same as the ones for Ubuntu.


This is the requirements for Ubuntu:

		"lsdiff"		=> "patchutils",
		"Digest::SHA1"		=> "libdigest-sha1-perl",
		"Proc::ProcessTable"	=> "libproc-processtable-perl",

Could you please double check if all of them also applies for Debian?

If so, then probably the enclosed patch will do the job. Could you
please test it as well?

Thanks,
Mauro

-

check_needs.pl: Add detection for Debian


Reported-by: Henning Hollermann <henning.hollermann@stud.uni-goettingen.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/check_needs.pl b/check_needs.pl
index 8060361..1467ee1 100755
--- a/check_needs.pl
+++ b/check_needs.pl
@@ -73,6 +73,10 @@ sub give_hints
 		give_ubuntu_hints;
 		return;
 	}
+	if ($system_release =~ /Debian/) {
+		give_ubuntu_hints;
+		return;
+	}
 
 	# Fall-back to generic hint code
 	foreach my $prog (@missing) {
