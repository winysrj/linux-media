Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62784 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1AKKhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 05:37:38 -0500
Received: by yib18 with SMTP id 18so5640455yib.19
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 02:37:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2AFC85.40709@redhat.com>
References: <201101072053.37211@orion.escape-edv.de>
	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
	<201101072206.30323.hverkuil@xs4all.nl>
	<AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>
	<4D2AFC85.40709@redhat.com>
Date: Tue, 11 Jan 2011 21:37:37 +1100
Message-ID: <AANLkTikgp1h5YzdqdwOMGOSizg_RG_dpY_FDb6TfxvMR@mail.gmail.com>
Subject: Re: Debug code in HG repositories
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 1/10/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Thanks for your script, but it seems specific to your environment. Could you
> please make it more generic and perhaps patch the existing build.sh script?

I was mainly intending to show how I happen to do this. It's way too complicated
compared to build.sh, which is a really nice solution.

> It would be nice to have some optional parameters there, to make life easier
> for end-users.

I can certainly try to supply some patches but I'm not sure what
parameters you have in mind.
build.sh is such a nice simple method; my script attempts to do
everything via git which is
overkill unless one is actively developing. Perhaps I could rework
into a distinct build_git.sh.

Cheers
Vince
