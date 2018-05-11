Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:53729 "EHLO
        homiemail-a81.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750798AbeEKUit (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 16:38:49 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: "Jasmin J." <jasmin@anw.at>, Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
 <3a039830-6ae8-406b-ede6-77553d7f45dd@anw.at>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <412dd3a2-b48e-3068-4181-37c66d664891@nextdimension.cc>
Date: Fri, 11 May 2018 15:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <3a039830-6ae8-406b-ede6-77553d7f45dd@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,


On 2018-05-11 15:02, Jasmin J. wrote:
> Hello Brad!
>
>> and which the media_build system does not pick up on for whatever
>> reason.
> Maybe it would be better to analyse why "make_config_compat.pl" selects
> wrongly the compatibility code.

I've found several reasons, but the one I seem to encounter often
is the symbols are located in files that the config_compat script
does not check for. Some symbols have moved between revisions,
so a check that works in 4.2 will fail in 3.10 and will also fail in 3.2.
I've also seen not-found symbols defined in arch/ code, which makes
it a little difficult to add additional paths to the search. There is also
the case of a maintainer who puts their backports wherever they
felt like and just glued things together in their build.

I'm not averse to handling this other ways, but while I was looking at
fixing make_config_compat.pl it just seemed that the script would
have to be made more complex. The search strategy would have to
change to include additional search paths, possibly depending on
kernel version as well as support to find symbols in the arch code,
while making sure the symbol was found in the correct target arch.

I know this is a workaround, but I have to do this 'workaround' in
some form for almost every package I maintain.


>
>> It seems there is quite often at least one backport I must disable,
>> and some target kernels require multiple backports disabled.
> This sounds strange. media-build should handle those cases correctly
> in my opinion and should be fixed.
> At least we should check why this happens.
>
> Patch 7/7 sounds like a workaround for me.
> If there is really no other solution, than we need to implement this
> possibility for distro maintainers.

This is not for distro maintainers. I am the lead engineer at Hauppauge
and and a responsibility of mine is the support our hardware on the
largest amount of systems and architectures possible. I work with
kernels anywhere from 3.2 to 4.15, all provided by either manufacturers
or distributions. Some are close to mainline, others not so much.

>
> On the other hand, why is media-build used by distro maintainers at all?
> I thought distro Kernels are built with a full tree and thus doesn't
> need media-build.
>
> BR,
>    Jasmin

I am not a distro maintainer. What I do is maintain and provide out of
tree driver packages for a large variety of systems, as well as in tree
integrations of the entire media tree for an assortment of Ubuntu kernels.

I have no influence over how a maintainer or distro publisher organizes
source code. I just take their tree and either compile the media_build
system out of tree, or integrate it completely. It is not very often I can
get *random_arch* kernel tree from *random_manufacturer* and
media_build 'just works'.

Like I said in the cover-letter, I'm totally open to better ways of handling
this. I am just honestly tired of having to fudge with things before every
new build, dirtying up the media_build tree. I like things reproducible and
clean and this seems to be the only thing left preventing that.

Cheers,

Brad
