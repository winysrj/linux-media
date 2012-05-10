Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38460 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2EJAIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 20:08:51 -0400
Received: by obbtb18 with SMTP id tb18so995177obb.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 17:08:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 May 2012 19:08:50 -0500
Message-ID: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com>
Subject: Advice on extending libv4l for media controller support
From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm interested in using libv4l along with my omap4 camera project to
adapt it more easily
to Android CameraHAL, and other applications, to reduce complexity of
them mostly...

So, but the difference is that, this is a media controller device I'm
trying to add support for,
in which I want to create some sort of plugin with specific media
controller configurations,
to avoid userspace to worry about component names and specific
usecases (use sensor resizer, or SoC ISP resizer, etc.).

So, I just wanted to know your advice on some things before I start
hacking your library:

1. Should it be the right thing to add a new subfolder under "lib/",
named like "libomap4iss-mediactl" or something like that ?
2. Do you know if anyone is working on something similar for any other
Media Controller device ?

Thanks in advance for your inputs.

Regards,
Sergio
