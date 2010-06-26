Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63428 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FZF3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 01:29:13 -0400
Received: by vws4 with SMTP id 4so196149vws.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jun 2010 22:29:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Jun 2010 13:29:12 +0800
Message-ID: <AANLkTinb4qKlVNsT0QKazgdJ6P7KDm3Z8UXdS8x4Li0B@mail.gmail.com>
Subject: Question on power management of usb web camera
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I am very curious about how v4l driver controls USB web camera's
power, e.g will it force device to a D3 low power state. Could anyone
show me which part of code is related with power management  and is
there any wiki guide on V4l's power?


Thanks!
Samuel
