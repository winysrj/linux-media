Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57038 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030725Ab0B0UAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:00:23 -0500
Date: Sat, 27 Feb 2010 21:00:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
Message-ID: <20100227210038.4b9f3c3f@tele>
In-Reply-To: <4B896E85.5040301@redhat.com>
References: <4B84CC9E.4030600@freemail.hu>
 <20100224082238.53c8f6f8@tele>
 <4B886566.8000600@freemail.hu>
 <4B88CF6C.2070703@redhat.com>
 <20100227100400.05fede81@tele>
 <4B893BBD.9030600@freemail.hu>
 <4B896E85.5040301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2010 20:12:05 +0100
Hans de Goede <hdegoede@redhat.com> wrote:
	[snip]
> I would like to note that even if we go the v4l2 control way it still
> makes sense to handle this in gspca_main, rather then implementing it
> separately in every sub driver.

There is nothing to do in the gspca_main: the control just does a
usb_control write.

> I say this as someone ... who is currnetly
> involved in writing a GTK v4l2 control panel application.

Great!

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
