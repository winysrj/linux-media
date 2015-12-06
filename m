Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36081 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbLFHf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2015 02:35:27 -0500
MIME-Version: 1.0
Date: Sun, 6 Dec 2015 09:35:26 +0200
Message-ID: <CAJ2oMhLh5EY=O3PCrgeOde2qFYJkVVC5H4dK5kwLqYWVUfmKqw@mail.gmail.com>
Subject: fbdev - wipe screen (dd) with ioctl ?
From: Ran Shalit <ranshalit@gmail.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I use the following to wipe a screen:
dd if=/dev/zero of=/dev/fb0 code

Is there a way to do the same thing in code (using ioctl I suppose) ?

Regards,
Ran
