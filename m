Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbcGCVbn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2016 17:31:43 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9C9AA60C6
	for <linux-media@vger.kernel.org>; Sun,  3 Jul 2016 21:31:42 +0000 (UTC)
Received: from shalem.localdomain (vpn1-5-247.ams2.redhat.com [10.36.5.247])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u63LVe7p028363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 3 Jul 2016 17:31:42 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
Subject: Stepping down as gspca and pwc maintainer
Message-ID: <0b81648e-90ab-e9b2-4192-a7a387e86fc0@redhat.com>
Date: Sun, 3 Jul 2016 23:31:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Admittedly I've not been all that active as gspca and pwc
maintainer lately, but officially I'm still the maintainer
for both.

Between my $dayjob, other foss projects and last but not
least spending time with my wife and children I'm way too busy
lately.

So I'm hereby officially stepping down as gspca and pwc maintainer,
I know this means MAINTAINERS needs updating, but I'm hoping to
find a volunteer to take them over who can then directly replace my
name in MAINTAINERS.

Both are currently in descent shape, one thing which needs
doing (for a long time now) is converting gspca to videobuf2.

Other then that the following patches are pending in
patchwork (and are all ready to be merged I just never
got around to it):

1 actual bug-fix which should really be merged asap
(Mauro can you pick this one up directly ?):

https://patchwork.linuxtv.org/patch/34155/

1 compiler warning:
https://patchwork.linuxtv.org/patch/32726/

A couple of v4l-compliance fixes:
https://patchwork.linuxtv.org/patch/33408/
https://patchwork.linuxtv.org/patch/33412/
https://patchwork.linuxtv.org/patch/33411/
https://patchwork.linuxtv.org/patch/33410/
https://patchwork.linuxtv.org/patch/33409/

And last there is this patch which need someone to review it:
https://patchwork.linuxtv.org/patch/34986/

Regards,

Hans
