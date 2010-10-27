Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0J0Mbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [GIT PATCHES FOR 2.6.37] Various gspca patches
Date: Wed, 27 Oct 2010 14:35:19 +0200
Message-Id: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please pull from:
http://linuxtv.org/hg/~hgoede/ibmcam3

Starting at the commit titled:
gspca: submit interrupt urbs *after* isoc urbs

This pull consists of the following commits:
gspca: submit interrupt urbs *after* isoc urbs
gspca: only set gspca->int_urb if submitting it succeeds
gspca-stv06xx: support bandwidth changing
gspca_xirlink_cit: various usb bandwidth allocation improvements / fixes
gspca_xirlink_cit: Frames have a 4 byte footer
gspca_xirlink_cit: Add support camera button
gspca_ov519: generate release button event on stream stop if needed

Note that since the hg v4l-dvb tree is a bit out of data, pulling from
my hg tree won't apply cleanly though. So to make things easier for you
I'm in the process of switching over to git. This mail will be followed
by the 7 patches from this pull request in git format-patch format, rebased
on top of the master branch of your git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git

The reason I'm not sending a git pull request is because I don't
have a git tree, and I could not find documentation for creating
a git tree @ git.linuxtv.org. Can you help me with this?

Also this wiki page:
http://linuxtv.org/wiki/index.php/Maintaining_Git_trees
Points to the obsolete: git://linuxtv.org/v4l-dvb.git
Repository, please update it.

Thanks & Regards,

Hans
