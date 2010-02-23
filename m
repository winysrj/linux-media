Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35861 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0BWLUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 06:20:47 -0500
Received: by fxm19 with SMTP id 19so3659036fxm.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 03:20:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002230026.59712.hverkuil@xs4all.nl>
References: <4B55445A.10300@infradead.org> <4B5B30E4.7030909@redhat.com>
	 <20100222225426.GC4013@jenkins.home.ifup.org>
	 <201002230026.59712.hverkuil@xs4all.nl>
Date: Tue, 23 Feb 2010 15:20:40 +0400
Message-ID: <1a297b361002230320l1b2ce3edx448222f2515ab5f8@mail.gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Brandon Philips <brandon@ifup.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 3:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Question: shouldn't we merge dvb-apps and v4l-utils? The alevtv tool was
> merged into dvb-apps, but while that tool supports dvb, it also supports
> v4l2. Just like we merged dvb and v4l in a single repository, so I think we
> should also merge the tools to a media-utils repository.



Alevt was never maintained. One of the guys who sent a patch wanted a
place to hold his patch and hence it is there.

If you have a better place to put it up, please do let me know. It's
place is not in the dvb-apps tree. It has other dependencies, hence
the build for it is disabled by default.


> It remains a fact of life that dvb and v4l are connected and trying to
> artificially keep them apart does not make much sense to me.


In fact, I don't see anything that's what is common in the digital and
analog applications.

Other than that, I don't see a single line of code from you, in
dvb-apps to make such assertive statements.


Regards,
Manu
