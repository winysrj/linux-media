Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64977 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0DYR5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 13:57:55 -0400
Received: by vws17 with SMTP id 17so959211vws.19
        for <linux-media@vger.kernel.org>; Sun, 25 Apr 2010 10:57:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004211144.19591@orion.escape-edv.de>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
	 <201004211144.19591@orion.escape-edv.de>
Date: Sun, 25 Apr 2010 10:57:54 -0700
Message-ID: <u2ka3ef07921004251057t36a6f9c3pe54a40fad3e8f515@mail.gmail.com>
Subject: Re: av7110 and budget_av are broken!
From: VDR User <user.vdr@gmail.com>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, e9hack <e9hack@googlemail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 21, 2010 at 2:44 AM, Oliver Endriss <o.endriss@gmx.de> wrote:
>> It's merged in Mauro's fixes tree, but I don't think those pending patches
>> have been pushed upstream yet. Mauro, can you verify this? They should be
>> pushed to 2.6.34!
>
> What about the HG driver?
> The v4l-dvb HG repository is broken for 7 weeks...

It doesn't make any sense why someone would break a driver and then
leave it that way for such a long period of time.  Yes, please fix the
HG repository.  I don't actually know anyone who bothers with the git
tree for obvious reasons, but a whole mess of users continue, of
course, to use the mercurial tree...
