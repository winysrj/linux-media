Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45217 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab1KBSoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 14:44:03 -0400
Received: by faao14 with SMTP id o14so701000faa.19
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2011 11:44:01 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: LMML <linux-media@vger.kernel.org>,
	"Patrick Dickey" <pdickeybeta@gmail.com>
Subject: Re: Adding PCTV80e support to linuxtv.
References: <4EA75010.3030806@gmail.com>
Date: Wed, 02 Nov 2011 19:44:01 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.v4b0znse3xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <4EA75010.3030806@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Oct 2011 02:10:56 +0200, Patrick Dickey <pdickeybeta@gmail.com>  
wrote:

> Hello everyone,
>
> Since my repository isn't under the linuxtv.org banner, I'm not sure how
> to create an actual patch or pull request for the code.  It needs some
> cleanup work, but essentially the code works (for the ATSC portion, but
> possibly not the QAM portion).
>
> The repository is located at  
> https://github.com/patrickdickey52761/PCTV80e
>
> so I'd imagine that either git clone
> git://github.com/patrickdickey52761/PCTV80e or git remote add
> git://github.com/patrickdickey52761/PCTV80e will pull the code in for
> you (it's a public repository).
>
> If this doesn't work, I'm asking for assistance in getting the code into
> a repository that can be pulled in (or assistance in how to prepare a
> patch/pull request from my current repository).
>
> If this does work, then I'm asking for assistance in cleanup of the
> code--and specifics on what I need to do to clean up the code (breaking
> lines up into fewer than 80 columns, whitespace, etc).  One thing to
> note is that I haven't removed the trailing whitespace from the
> drxj_map.h file, as it was an automatically generated file. I wasn't
> sure what implications could arise from altering the file.
>
> Thank you, and have a great day:)
> Patrick.

Hi,

I'm not a developer, but I have some basic understanding how v4l patching  
works.

You don't have to have a repository online, you can simply submit patches  
 from your local tree using git or hg or even diff tools. Patches should  
come from newer trees (preferably current development tree) so they could  
apply cleanly.

Please read the following links and see if they could help:
	http://linuxtv.org/wiki/index.php/Developer_Section
	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches


