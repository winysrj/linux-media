Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44742 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaATSqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 13:46:31 -0500
Received: by mail-qc0-f173.google.com with SMTP id i8so6283941qcq.32
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 10:46:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DD6D2E.2040900@fnxweb.com>
References: <52DC04E8.8020406@fnxweb.com>
	<CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
	<52DD6A48.8000003@fnxweb.com>
	<CALzAhNVY9SSB_7c57RuN5ZSo6hqfMiq1tBVLzBmvznY9h7dd6g@mail.gmail.com>
	<52DD6D2E.2040900@fnxweb.com>
Date: Mon, 20 Jan 2014 13:46:29 -0500
Message-ID: <CALzAhNUD-30=yoZh3rUUMka2KX83_8K4c+StYicHUoHh5019gw@mail.gmail.com>
Subject: Re: Problem getting sensible video out of Hauppauge HVR-1100 composite
From: Steven Toth <stoth@kernellabs.com>
To: Neil Bird <gnome@fnxweb.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>   S-video requirements are a dying breed, unfortunately.
>
>   Don't suppose you know of any?  I see the Hauppauge HVR-2200 does, but it
> looks like the drivers for that are a bit too “fresh” for me to be able to
> risk another blind purchase (and may require kernel 3.2+, where I'm on SL6
> with 2.6.~32).

I'd backport the HVR2200 driver into 2.6.32 (it may already exist with
analog features in .32 btw) and go with a 2200.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
