Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4844 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2D1PKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [RFCv1 PATCH 0/7] gspca: allow use of control framework and other fixes
Date: Sat, 28 Apr 2012 17:09:49 +0200
Message-Id: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is a patch series that makes it possible to use the control framework
in gspca. The gspca core changes are very minor but as a bonus give you
priority support as well.

The hard work is in updating the subdrivers. I've done two, and I intend
to do the stv06xx driver as well, but that's the last of my gspca webcams
that I can test. Looking through the subdrivers I think that 50-70% are in
the category 'easy to convert', the others will take a bit more time
(autogain/gain type of constructs are always more complex than just a simple
brightness control).

After applying this patch series the two converted drivers pass the
v4l2-compliance test as it stands today.

Comments? Questions?

Regards.

	Hans

