Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:50286 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZJaRZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 13:25:45 -0400
Received: by qyk4 with SMTP id 4so2019370qyk.33
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 10:25:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <39773.124.176.234.179.1256823213.squirrel@webmail.student.unimelb.edu.au>
References: <ef52a95d0910192350t457ba959x8d2f1cce82585a3b@mail.gmail.com>
	 <303a8ee30910200448w3b876678n8cc029947e08f4a5@mail.gmail.com>
	 <2132.172.21.180.242.1256691058.squirrel@webmail.student.unimelb.edu.au>
	 <303a8ee30910280556u16b764enf68b74b9e37c65a0@mail.gmail.com>
	 <39773.124.176.234.179.1256823213.squirrel@webmail.student.unimelb.edu.au>
Date: Sat, 31 Oct 2009 13:25:49 -0400
Message-ID: <303a8ee30910311025t6d1ce1fch5d11d60d0f2e5c3d@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S remote control support
From: Michael Krufky <mkrufky@kernellabs.com>
To: Michael Carl Obst <m.obst@ugrad.unimelb.edu.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 29, 2009 at 9:33 AM, Michael Carl Obst
<m.obst@ugrad.unimelb.edu.au> wrote:
> I am having trouble with the current repository, I can build and install
> it fine but I can't insert the modules, I'm getting two different errors
> which I haven't looked into yet. I have regenerated the patch anyway and
> it builds fine but due to the other problems have not been able to check
> it is still working (although I see no reason why it wouldn't).

As you may have seen from the other email thread, there was a problem
in the way that the DTV1000S patch was merged.  Thanks to Hermann for
pointing it out, I fixed the DTV1000S tree, and added your remote
control patch.  Hopefully Mauro will merge it soon.

If you see any more problems, please let us know.

Cheers,

Mike
