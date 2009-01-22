Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:35764 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZAVEGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 23:06:47 -0500
Date: Wed, 21 Jan 2009 22:17:55 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Driver Development <sqcam-devel@lists.sourceforge.net>,
	Gerard Klaver <gerard@gkall.hobby.nl>
Subject: Why not to try to combine sq905 and sq
In-Reply-To: <20090121182033.278f213d@free.fr>
Message-ID: <Pine.LNX.4.64.0901212149040.25576@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <20090121182033.278f213d@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 21 Jan 2009, Jean-Francois Moine wrote:

(previous material covered a different topic)

> Now, the request: some guys asked for support of their webcams based on
> sq930x chips. A SANE backend driver exists, written by Gerard Klaver
> (http://gkall.hobby.nl/sq930x.html).
> May you have a look and say if handling these chips may be done in your
> driver?

I am sorry to have been rather brief about this one in my previous 
message, but I am quite serious in saying "no." Clearly it is always 
possible somehow to jam-fit the support for two or more very different 
devices into one block of code. One would require some kind of branching 
at every logical step in the code, and nobody would be able to read it and 
make sense of that code, or to maintain it.

In this present case of the sq930x, I did look at Gerard's information.
Indeed, the very structure of the commands is different from the commands
for the sq905 and for that matter from the sq905c cameras, with both of
which I am intimately familiar. A mere glance at the file

creative protocol I420.txt

at Gerard's web page suffices to show that the command sequences are 
completely different. One can add to this that the frames are JPEG, 
whereas the frames for the sq905 are uncompressed bitmap data.

I would be glad to help with the sq930x if there is any help I can give 
and if the help is wanted. Anyone who wants me to do that should just ask. 
But that is a totally different matter from trying to glue together the 
support for two very unlike devices in one driver module, apparently for 
the reason that the two devices share the same Vendor number.

As a very relevant analogy, permit me to say that I wrote the driver in
libgphoto2 for the Logitech Clicksmart 310 camera. When it became clear
that this is yet another spca50x camera, I contacted the person who had
written the unified spca50x driver for libgphoto2 and asked him if,
because of this, he wanted this new spca5x camera to be included there. I
sent him my code. He looked at it, and he said to leave it as a separate
driver. In spite of using the same chipset, the camera was just too
different. He further added that he was sorry he had tried to put so many
cameras into one driver in the first place, had learned a lesson from the
experience, and if he had it to do over again he would not.

Theodore Kilgore
