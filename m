Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:39792 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaASRyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 12:54:47 -0500
Received: by mail-qa0-f48.google.com with SMTP id f11so4944403qae.35
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 09:54:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DC04E8.8020406@fnxweb.com>
References: <52DC04E8.8020406@fnxweb.com>
Date: Sun, 19 Jan 2014 12:54:47 -0500
Message-ID: <CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
Subject: Re: Problem getting sensible video out of Hauppauge HVR-1100 composite
From: Steven Toth <stoth@kernellabs.com>
To: Neil Bird <gnome@fnxweb.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>   I set everything I know of up OK, but when I access /dev/video0 I get a
> garbled pink MPEG file (cat to a file, then mplayer to test).  The DVB-T
> aspect of is works fine (tested using vlc).

It doesn't have a MPEG hardware compressor like the 350, you are
reading raw pixel data (160Mbps) from the device node.

Use an application that renders raw video data, such as TVTime.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
