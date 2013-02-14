Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47447 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3BNKNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 05:13:19 -0500
Received: by mail-wi0-f178.google.com with SMTP id o1so2501362wic.11
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 02:13:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302140912.59216.hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
	<CA+6av4kxho5-UJB=BCTqd+qH-ATGzBUvds7TDpenjb7W73rKVQ@mail.gmail.com>
	<201302120928.55962.hverkuil@xs4all.nl>
	<201302140912.59216.hverkuil@xs4all.nl>
Date: Thu, 14 Feb 2013 10:13:18 +0000
Message-ID: <CA+6av4mkXo9caeKUpHWAJjALio202-YnO21Z-UOSpZK9caP-hg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup
 was the wrong way around
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 14, 2013 at 8:12 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Arvydas, can you please test this? I'd like to do a git pull tomorrow and I'd
> like to know if the upside-down changes are now OK.
>
> Thanks,
>

Hi Hans

Everything is working fine now - dmesg is clean, LED lights on and off
when needed, viewport angle is correct.

Thanks for the fixes.

Arvydas
