Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:56029 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZKHOQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 09:16:21 -0500
Received: by fg-out-1718.google.com with SMTP id d23so398797fga.1
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 06:16:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
	 <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
	 <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
	 <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
Date: Sun, 8 Nov 2009 09:16:25 -0500
Message-ID: <829197380911080616r32a35653u584dd24f25332284@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 7, 2009 at 9:40 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Hello Vince,
>
> I think the next step at this point is for you to definitively find a
> use case that does not work with the latest v4l-dvb tip and Robert's
> patch, and include exactly what kernel you tested with and which board
> is having the problem (including the PCI or USB ID).
>
> At this point, your description seems a bit vague in terms of what is
> working and what is not.  If you do the additional testing to narrow
> down specifically the failure case you are experiencing, I will see
> what I can do.
>
> That said, I'm preparing a tree with Robert's patch since I am pretty
> confident at least his particular problem is now addressed.
>
> Thanks,
>
> Devin

Robert,

FYI:  this has been merged into my local tree (after fixing some
whitespace problems introduced by the inlining of the patch into the
email).  I'll issue a PULL request tonight.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
