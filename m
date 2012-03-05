Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34305 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2CEMBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 07:01:47 -0500
Date: Mon, 5 Mar 2012 13:03:18 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Xavion <xavion.0@gmail.com>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux
 anymore
Message-ID: <20120305130318.458bd040@tele>
In-Reply-To: <4F547A4E.9090703@redhat.com>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
	<CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
	<4F51CCC1.8020308@redhat.com>
	<CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
	<20120304082531.1307a9ed@tele>
	<CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
	<4F547A4E.9090703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 05 Mar 2012 09:33:18 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> I guess that motion is using the JPG compressed frames rather then
> the i420 like special format these cameras also support, and it looks
> like we don't reserve enoug space to buffer these frames. To fix this
> we need to enlarge the size we reserve per frame in the sn9c20x driver,
> edit sn9c20x.c and search for vga_mode, in that table you will
> find a factor "4 / 8" (its in there 3 times), change all 3 occurences
> to "5 / 8" and try again, then "6 / 8", etc.
> 
> Normally I would be suspicious about SOF / EOF detection when we
> need such a factor, but the timestamps in your log exactly match 30
> fps, so that seems to be fine. And in my experience with the USB bandwidth
> stuff the sn9c20x does seem to compress less then other JPG cams, so
> it makes sense that it needs bigger buffers to store the frames too.

Hi Hans,

The JPEG compression quality of the sn9c20x is 95%. That's why the
frames are so big. Then, if the quality is not settable, I wonder why
to use the JPEG format.

BTW, I wonder also about the SN9C20X_I420: this format asks for a
buffer greater than the native image. So, as these webcams are USB 2.0,
shouldn't it be simpler to have only Bayer in the driver?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
