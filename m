Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49305 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1JPVSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 17:18:12 -0400
Received: by iaek3 with SMTP id k3so5293061iae.19
        for <linux-media@vger.kernel.org>; Sun, 16 Oct 2011 14:18:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e9b3dff.e766e30a.54ec.4d44@mx.google.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
	<CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
	<CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com>
	<4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
	<CAATJ+fstZmoctKrv8Owv53-oEPOn6C8d5FOwMAmLL=7R8UwYzg@mail.gmail.com>
	<4E93481F.8010205@iki.fi>
	<1318278450.16238.15.camel@localhost>
	<CAATJ+fub_tmoXxxPKU1vBnRNT=7MEUTn0T=_+iP2koj7N4MBrA@mail.gmail.com>
	<4e9b3dff.e766e30a.54ec.4d44@mx.google.com>
Date: Mon, 17 Oct 2011 08:18:11 +1100
Message-ID: <CAATJ+fsAjEkBTaOUhtSBmQOOs7YUBZ61xAyc-guxJMS7avVEAg@mail.gmail.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Jason Hecker <jwhecker@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Trouble is, on a Nvidia motherboard I have it does not do it at all and
> all applications work without any troubles.  This seems to suggest a USB
> motherboard driver issue.

Right.  Well, I can say with high confidence that my dual tuner worked
flawlessly for 18 months using Ubuntu's kernel 2.6.32 up until some
update around May.   Some kernel (or other) update apparently made it
all go pear shaped which prompted me to get another card then update
the whole system to try fix the problem - I haven't gone back to an
old 2.6.32 kernel.  So I am wondering if some other non v4l related
patch has affected us all.

> I am continuing to look into it.

OK, well I am still running my system with your two patches, with
corruptions alas, so if you'd like me to independently try stuff out
let me know.

Jason
