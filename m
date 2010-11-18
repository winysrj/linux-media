Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55106 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab0KROlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 09:41:00 -0500
Received: by yxf34 with SMTP id 34so1837815yxf.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 06:41:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
	<659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
Date: Thu, 18 Nov 2010 09:40:59 -0500
Message-ID: <AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 07/15] dsbr100: convert to unlocked_ioctl.
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This driver has quite a few locking issues that would only be made
worse by your patch. A much better patch for this can be found here:

http://desource.dyndns.org/~atog/gitweb?p=linux-media.git;a=commitdiff;h=9c5d8ebb602e9af46902c5f3d4d4cc80227d3f7c

Regards,

David Ellingsworth
