Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1AKOVo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 09:21:44 -0500
Message-ID: <4D2C8393.3040401@redhat.com>
Date: Tue, 11 Jan 2011 14:21:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de>	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>	<201101072206.30323.hverkuil@xs4all.nl>	<AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>	<4D2AFC85.40709@redhat.com> <AANLkTikgp1h5YzdqdwOMGOSizg_RG_dpY_FDb6TfxvMR@mail.gmail.com>
In-Reply-To: <AANLkTikgp1h5YzdqdwOMGOSizg_RG_dpY_FDb6TfxvMR@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-01-2011 08:37, Vincent McIntyre escreveu:
> On 1/10/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Thanks for your script, but it seems specific to your environment. Could you
>> please make it more generic and perhaps patch the existing build.sh script?
> 
> I was mainly intending to show how I happen to do this. It's way too complicated
> compared to build.sh, which is a really nice solution.
> 
>> It would be nice to have some optional parameters there, to make life easier
>> for end-users.
> 
> I can certainly try to supply some patches but I'm not sure what
> parameters you have in mind.
> build.sh is such a nice simple method; my script attempts to do
> everything via git which is
> overkill unless one is actively developing. Perhaps I could rework
> into a distinct build_git.sh.

That could be interesting. For those using git trees, the better way is to use
	make -C linux DIR=<git dir>

This needs to be done just once, as it will store some info at linux/.linked_dir.
It will basically store there the directory with the git tree, and the hashes of
the original, media_build original copy and media_build copy after patched. Every
time someone tries to compile, it re-checks the hashes and re-copy the file from
the git tree, if needed.

Cheers,
Mauro
