Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373Ab1FAKxZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 06:53:25 -0400
Message-ID: <4DE61A1F.8050901@redhat.com>
Date: Wed, 01 Jun 2011 07:53:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Randy Dunlap <rdunlap@xenotime.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L2_PIX_FMT_JPGL is missing a proper documentation at V4L2 API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jean-François,

I've added on our tree a DocBook patch that helps to detect the
gaps between the videodev2.h header and the specs. It is complaining
that a symbol is missing:

Error: no ID for constraint linkend: V4L2-PIX-FMT-JPGL.

According with videodev2, this is a "JPEG-Lite" FOURCC:

include/linux/videodev2.h:#define V4L2_PIX_FMT_JPGL       v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */

This were introduced by this commit:

commit ce5b2acce60405b938d1f1f994024cde4e2cdd7e
Author: Jean-François Moine <moinejf@free.fr>
Date:   Mon Mar 14 08:49:28 2011 -0300

    [media] gspca - nw80x: New subdriver for Divio based webcams

Could you please provide us the proper documentation for the new symbol?

Thanks!
Mauro.
