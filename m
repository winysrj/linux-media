Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33504 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZAUS7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 13:59:12 -0500
Date: Wed, 21 Jan 2009 13:10:19 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Driver Development <sqcam-devel@lists.sourceforge.net>,
	Gerard Klaver <gerard@gkall.hobby.nl>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <20090121182033.278f213d@free.fr>
Message-ID: <Pine.LNX.4.64.0901211248001.25120@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <20090121182033.278f213d@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 21 Jan 2009, Jean-Francois Moine wrote:

<snip>

> Hello Adam and Theodore,
>
> I looked at your two versions, and I think the first one (work queue)
> is the simplest. So, I am ready to put your driver in my repository for
> inclusion in a next linux kernel.

Thank you.

>
> I have just a few remarks and a request.

The remarks need close attention, which will be applied. Thank you again 
for attention to detail. The request I can deal with right now.

> Now, the request: some guys asked for support of their webcams based on
> sq930x chips. A SANE backend driver exists, written by Gerard Klaver
> (http://gkall.hobby.nl/sq930x.html).
> May you have a look and say if handling these chips may be done in your
> driver?

In a word, no. Sorry. The only real resemblance of either of these devices 
to the other is that they share the same Vendor number.

Now, thanks again for the comments. Adam and I will get busy on them.

Theodore Kilgore
