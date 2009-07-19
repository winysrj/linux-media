Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34891 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZGSJLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 05:11:03 -0400
Date: Sun, 19 Jul 2009 11:11:45 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Brian Johnson <brijohn@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev3
Message-ID: <20090719111145.50db44ee@free.fr>
In-Reply-To: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
References: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Jul 2009 00:10:50 -0400
Brian Johnson <brijohn@gmail.com> wrote:

> Ok this one just has the following minor changes:
> 
> * operations set/get_register in the sd descriptor only exist if
> CONFIG_VIDEO_ADV_DEBUG is defined
> * use lowercase letters in hexidecimal notation
> * add new supported webcams to
> linux/Documentation/video4linux/gspca.txt
> * check for NULL after kmalloc when creating jpg_hdr

Hello, Brian and Mauro,

I got the patches and sent a pull request. The changesets have a high
priority.

I just fixed a compilation warning issued when USB_GSPCA_SN9C20X_EVDEV
was not set.

Mauro, I could not update the maintainers list. Do you want Brian sends
a new patch for that?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
