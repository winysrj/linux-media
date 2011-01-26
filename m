Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:52505 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1AZOiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 09:38:07 -0500
Received: by pxi15 with SMTP id 15so75617pxi.19
        for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 06:38:06 -0800 (PST)
References: <AANLkTiktFYcJwJePy=jjeo2qGHWip52cZyCkCDTgdFmc@mail.gmail.com> <AANLkTimn5nPjsZnJ2NVrpXkBZamhiPSf-R6jSpZixCwS@mail.gmail.com> <AANLkTimcM8fy9Cu8Xuk=M74WBnfoG9gyb7zLqcQV2Hoa@mail.gmail.com>
In-Reply-To: <AANLkTimcM8fy9Cu8Xuk=M74WBnfoG9gyb7zLqcQV2Hoa@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <8C123C68-4541-4DC8-9F3C-B887AC247DA7@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Is media_build download broken?
Date: Wed, 26 Jan 2011 09:38:16 -0500
To: VDR User <user.vdr@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 26, 2011, at 12:11 AM, VDR User wrote:

> On Tue, Jan 25, 2011 at 8:30 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>>> I'm getting the following now:
>>> 
>>> git pull ssh://linuxtv.org/git/media_build master
>>> Permission denied (publickey).
>> 
>> Works here just fine. Looks like your ssh key setup is amiss.
> 
> I deleted my ~/.ssh/known_hosts and I'm getting this:
> 
> Cloning into media_build...
> remote: Counting objects: 682, done.
> remote: Compressing objects: 100% (335/335), done.
> remote: Total 682 (delta 382), reused 572 (delta 313)
> Receiving objects: 100% (682/682), 235.82 KiB | 140 KiB/s, done.
> Resolving deltas: 100% (382/382), done.
> ************************************************************
> * This script will download the latest tarball and build it*
> * Assuming that your kernel is compatible with the latest  *
> * drivers. If not, you'll need to add some extra backports,*
> * ./backports/<kernel> directory.                          *
> * It will also update this tree to be sure that all compat *
> * bits are there, to avoid compilation failures            *
> ************************************************************
> git pull ssh://linuxtv.org/git/media_build master
> The authenticity of host 'linuxtv.org (130.149.80.248)' can't be established.
> RSA key fingerprint is fa:d5:ff:8c:63:e1:59:38:79:8b:9a:bf:bc:81:6b:92.
> Are you sure you want to continue connecting (yes/no)?

Seems that an explicit 'pull over ssh' command was recently added
to media_build, which only works if you've got a shell account on
linuxtv.org. I'll ask Mauro about it and/or just fix it.

-- 
Jarod Wilson
jarod@wilsonet.com



