Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1IZL1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:27:30 -0400
Received: by iaqq3 with SMTP id q3so4439097iaq.19
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 04:27:29 -0700 (PDT)
Message-ID: <4E80619D.2080803@gmail.com>
Date: Mon, 26 Sep 2011 06:27:25 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: Johannes Stezenbach <js@linuxtv.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Problems cloning the git repostories
References: <4E7F1FB5.5030803@gmail.com> <20110925180340.GB23820@linuxtv.org> <4E7FE9E8.3010404@gmail.com>
In-Reply-To: <4E7FE9E8.3010404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I ran into that issue yesterday, but figured that I'd caused enough of a
headache asking about the problems already--so I decided to wait and see
if it was fixed this morning.

Thank you (even though I didn't report the issue), and have a great day:)
Patrick.

On 09/25/2011 09:56 PM, Mauro Carvalho Chehab wrote:
> Em 25-09-2011 15:03, Johannes Stezenbach escreveu:
>> On Sun, Sep 25, 2011 at 07:33:57AM -0500, Patrick Dickey wrote:
>>>
>>> I tried to follow the steps for cloning both the "media_tree.git" and
>>> "media_build.git" repositories, and received errors for both.  The
>>> media_tree repository failed on the first line
>>>
>>>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb 
>>>
>>> which I'm assuming is because kernel.org is down.
>>>
>>> The media_build.git repository fails on the first line also
>>>
>>>> git clone git://linuxtv.org/media_build.git 
>>>
>>> with a fatal: read error: Connection reset by peer.
>>
>> The git error should be fixed now.
>>
>> But please don't clone from linuxtv.org, intead use
>> git clone git://github.com/torvalds/linux.git
>> and then add linuxtv to your repo like described on
>> http://git.linuxtv.org/media_tree.git
> 
> I've updated the instructions together with the git tree to point to the
> github tree.
> 
> Btw, the media_build had an issue due to the move of tm6000 and altera-stapl
> out of staging. I've fixed it. At least here with 3.0 kernel, everything
> is compiling fine.
> 
> Cheers,
> Mauro
>>
>>
>> Johannes
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6AYZ0ACgkQMp6rvjb3CAQj1QCffarBsYJw3Dx8sowrXF0i0gnF
tugAoKBFVFcRcX8jHyQM1vMKpX3qz6Ks
=GGGa
-----END PGP SIGNATURE-----
