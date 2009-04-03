Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:10868 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZDCCtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 22:49:22 -0400
Received: by wf-out-1314.google.com with SMTP id 29so968777wff.4
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 19:49:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e9665e10904020325t3567c442t2fce7bcc32aa8940@mail.gmail.com>
References: <5e9665e10904020325t3567c442t2fce7bcc32aa8940@mail.gmail.com>
Date: Fri, 3 Apr 2009 11:49:21 +0900
Message-ID: <5e9665e10904021949uf3884c7s64bb362f4363fb16@mail.gmail.com>
Subject: Re: Compile error in v4l2-spec
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm answering myself.
I solved compile error that I mentioned yesterday,

Problem is all about DTD and sh in ubuntu distribution.
I'm still not sure what package do I exactly need to solve this
problem, but I did like following.

I searched all the packages related with sgml and selected which
contains DTD things.
sudo apt-cache search sgml | grep DTD
and install all of them. (shame ;-()

and also do the same thing with docbook with DTD things like this,
sudo apt-cache search docbook | grep DTD

and remove /bin/sh which is symbolic linked to /bin/dash
and make a symbolic link with bash (not sure this is right)

and finally I've got single compiled html v4l2 spec.

Cheers,

Nate

On Thu, Apr 2, 2009 at 7:25 PM, Dongsoo, Nathaniel Kim
<dongsoo.kim@gmail.com> wrote:
> Hi,
>
> I'm trying to make some v4l2-spec document on my own, but having some
> problem with compiling those.
> To be clear, I should let you know about the repo that I'm working on.
> I'm working on Mauro's repo (http://linuxtv.org/hg/v4l-dvb/)
> and trying to compile v4l2-spec in that.
> Latest changeset that I have in it is
>
> changeset:   11341:4c7466ea8d64
> tag:         tip
> parent:      11335:23836942be90
> parent:      11340:2f6cf8db5325
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Wed Apr 01 07:36:31 2009 -0300
> summary:     merge: http://linuxtv.org/hg/~anttip/af9015/
>
>
> and I'm having errors like following
>
> Using catalogs: /etc/sgml/catalog
> Using stylesheet: /home/kdsoo/work/v4l-dvb/v4l2-spec/custom.dsl#html
> Working on: /home/kdsoo/work/v4l-dvb/v4l2-spec/v4l2.sgml
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/v4l2.sgml:1:55:W: cannot
> generate system identifier for public text "-//OASIS//DTD DocBook
> V3.1//EN"
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:2:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:13:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:80:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:83:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:116:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:166:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:183:0:E:
> character "-" not allowed in declaration subset
> openjade:/home/kdsoo/work/v4l-dvb/v4l2-spec/entities.sgml:209:0:E:
> character "-" not allowed in declaration subset
> ...................
> <snip>
>
>
> I don't have any clue about this. What should I do?
> I'm trying this on my Ubuntu 8.10 machine.
> Any help should be appreciated.
> Cheers,
>
> Nate
>
> --
> ========================================================
> DongSoo, Nathaniel Kim
> Engineer
> Mobile S/W Platform Lab.
> Digital Media & Communications R&D Centre
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>          dongsoo45.kim@samsung.com
> ========================================================
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
