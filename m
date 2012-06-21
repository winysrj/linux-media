Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38994 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2FUPIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 11:08:53 -0400
Received: by obbuo13 with SMTP id uo13so1048929obb.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 08:08:52 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Jun 2012 12:08:52 -0300
Message-ID: <CALF0-+U9_g64bekEDpjJwkKZrCjbXwArSRxGamG0XR1JN6qG4w@mail.gmail.com>
Subject: [Q] What's preventing solo6x10 driver from moving out of staging
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	bcollins@bluecherry.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

solo6x10 TODO file says this:

TODO (staging => main):

        * Motion detection flags need to be moved to v4l2
        * Some private CIDs need to be moved to v4l2

But I could not find any v4l2 motion detection flag. I guess it's a
new kind of flag that needs to be added.

Also, what happened with the mainline effort? (Assuming there was one :-)

Regards,
Ezequiel.
