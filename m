Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56368 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524Ab2BWS5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 13:57:07 -0500
Received: by obcva7 with SMTP id va7so1779284obc.19
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2012 10:57:06 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 23 Feb 2012 15:57:06 -0300
Message-ID: <CALF0-+XGhKnFxWfdWptMezrTW3hcod-HG4jC9BU___4LosR7cQ@mail.gmail.com>
Subject: [question] USB video capture reference driver
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm doing some work on easycap (staging) driver
and I would like to ask which similar driver is available
and/or recommended to follow code style and code design.

Reading cx231xx driver I noticed that video buffer allocation
and ioctl handling are done in a very different way using some
v4l facilities.
I believe this would be prefered over the current status, right?

Thanks,
Ezequiel.
