Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:48212 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965510Ab0COSL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 14:11:57 -0400
Date: Mon, 15 Mar 2010 19:12:39 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: mightyiampresence@gmail.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Cc: email@shahar-or.co.il, rcml@lecurie.org, ropers <ropers@gmail.com>,
	Jean-Yves Lamoureux <jylam@lnxscene.org>,
	linux-media@vger.kernel.org
Subject: Re: [Spca50x-devs] 17a1:0118
Message-ID: <20100315191239.54f4c6fa@tele>
In-Reply-To: <bf87febf1003151024k7987318bv6f76a40c4d7daeee@mail.gmail.com>
References: <bf87febf1003151024k7987318bv6f76a40c4d7daeee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Mar 2010 19:24:24 +0200
Shahar Or <email@shahar-or.co.il> wrote:

> I have a non-supported one, with the ID 17a1:0118. Data attached.
> 
> I am willing to cooperate with anything that I can, including testing
> patches.
> 
> I've noticed there's one here related:
> http://lists-archives.org/spca50x-devs/01649-patch-for-17a1-0128-xpx-jpeg-webcam-tascorp.html
> 
> I can also send the cam over by mail, if that is necessary.
> 
> I'm subscribed to the list.

Hello Shahar,

A driver for this webcam is available (you may find it in the last
gspca version that I have just uploaded - 2.9.6 - the subdriver is
'gspca_tasc.ko').

The only problem is that nobody could yet decode the images! (Jens,
Jean-Yves, any news?)

About the list, all the linux video stuff is hosted at LinuxTv.org and
the linux-media mailing-list at vger.kernel.org (see Cc:).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
