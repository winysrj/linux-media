Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44344 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2CER0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 12:26:03 -0500
Date: Mon, 5 Mar 2012 18:27:36 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xavion <xavion.0@gmail.com>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux
 anymore
Message-ID: <20120305182736.563df8b4@tele>
In-Reply-To: <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
	<CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
	<4F51CCC1.8020308@redhat.com>
	<CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
	<20120304082531.1307a9ed@tele>
	<CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Mar 2012 08:58:30 +1100
Xavion <xavion.0@gmail.com> wrote:

> I can confirm that GSPCA v2.15.1 removes the bad pixels when I use
> Cheese or VLC.  However, I'm sorry to report that the Motion problems
> unfortunately still remain.  Is there something else I must do to
> overcome the below errors?  I'm happy to keep testing newer GSPCA
> versions for you until we get this fixed.

Hi again,

I looked at the driver again, and thanks to Hans, I found you could
easily lower the JPEG compression quality and stop buffer overflow.

At line 2093 of build/sn9c20x.c (gspca test), there is:

	sd->quality = 95;

Changing '95' to '80' should be enough.

I will add this parameter as a video control as soon as it will be
standard. Then you could adjust it with an external program as v4l2ucp.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
