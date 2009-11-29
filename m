Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37108 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZK2MPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:15:06 -0500
Date: Sun, 29 Nov 2009 13:15:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca main: reorganize loop
Message-ID: <20091129131511.2bb26f2b@tele>
In-Reply-To: <4B1258D2.7060706@freemail.hu>
References: <4B124BDF.50309@freemail.hu>
	<20091129113834.6b47767a@tele>
	<4B1258D2.7060706@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Nov 2009 12:19:46 +0100
Németh Márton <nm127@freemail.hu> wrote:

> Is there any subdriver where the isoc_nego() is implemented? I
> couldn't find one. What would be the task of the isoc_nego()
> function? Should it set the interface by calling usb_set_interface()
> as the get_ep() does? Should it create URBs for the endpoint?
> 
> Although I found the patch where the isoc_nego() was introduced
> ( http://linuxtv.org/hg/v4l-dvb/rev/5a5b23605bdb56aec86c9a89de8ca8b8ae9cb925 )
> it is not clear how the "ep" pointer is updated when not the
> isoc_nego() is called instead of get_ep() in the current
> implementation.

Hello Hans,

This function (isoc_nego) was added to fix the Mauro's problem with the
st6422. Was this problem solved in some other way, or is the fix still
waiting to be pulled?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
