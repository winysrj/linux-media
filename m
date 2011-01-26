Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35052 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1AZFLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 00:11:12 -0500
Received: by iyj18 with SMTP id 18so30917iyj.19
        for <linux-media@vger.kernel.org>; Tue, 25 Jan 2011 21:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimn5nPjsZnJ2NVrpXkBZamhiPSf-R6jSpZixCwS@mail.gmail.com>
References: <AANLkTiktFYcJwJePy=jjeo2qGHWip52cZyCkCDTgdFmc@mail.gmail.com>
	<AANLkTimn5nPjsZnJ2NVrpXkBZamhiPSf-R6jSpZixCwS@mail.gmail.com>
Date: Tue, 25 Jan 2011 21:11:12 -0800
Message-ID: <AANLkTimcM8fy9Cu8Xuk=M74WBnfoG9gyb7zLqcQV2Hoa@mail.gmail.com>
Subject: Re: Is media_build download broken?
From: VDR User <user.vdr@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 25, 2011 at 8:30 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> I'm getting the following now:
>>
>> git pull ssh://linuxtv.org/git/media_build master
>> Permission denied (publickey).
>
> Works here just fine. Looks like your ssh key setup is amiss.

I deleted my ~/.ssh/known_hosts and I'm getting this:

Cloning into media_build...
remote: Counting objects: 682, done.
remote: Compressing objects: 100% (335/335), done.
remote: Total 682 (delta 382), reused 572 (delta 313)
Receiving objects: 100% (682/682), 235.82 KiB | 140 KiB/s, done.
Resolving deltas: 100% (382/382), done.
************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
git pull ssh://linuxtv.org/git/media_build master
The authenticity of host 'linuxtv.org (130.149.80.248)' can't be established.
RSA key fingerprint is fa:d5:ff:8c:63:e1:59:38:79:8b:9a:bf:bc:81:6b:92.
Are you sure you want to continue connecting (yes/no)?
