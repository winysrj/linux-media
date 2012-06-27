Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55075 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0JhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 05:37:24 -0400
Received: by obbuo13 with SMTP id uo13so1227369obb.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 02:37:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 17:37:24 +0800
Message-ID: <CAHG8p1DaJPWwSxmMqk6Jkx8JO8m69OuTYpwHvhsB54e8RAMRVA@mail.gmail.com>
Subject: About s_std_output
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I noticed there are two s_std ops in core and video for output. And
some drivers call video->s_std_out and then core->s_std in their S_STD
iotcl. Could anyone share me the story why we have
s_std_output/g_std_output/g_tvnorms_output ops in video instead of
making use of s_std/g_std in core?

Thanks,
Scott
