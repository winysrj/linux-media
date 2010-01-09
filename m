Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55425 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0AIMew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 07:34:52 -0500
Date: Sat, 9 Jan 2010 13:36:02 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca - pac7302: Add a delay on loading the bridge registers.
Message-ID: <20100109133602.01c34ce9@tele>
In-Reply-To: <4B476B5E.7040909@freemail.hu>
References: <4B476B5E.7040909@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 08 Jan 2010 18:29:02 +0100
Németh Márton <nm127@freemail.hu> wrote:

> > Without the delay, the usb_control_msg() may fail when loading the
> > page 3 with error -71 or -62.
> >
> > Priority: normal
> >
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>  
> 
> include/asm-generic/errno.h:
> > #define ETIME           62      /* Timer expired */
> > #define EPROTO          71      /* Protocol error */  
> 
> I'm interested in which device have you used for testing this?

Hi,

These errors occured with the webcam 06f8:3009, but I do not know
exactly how. I thought about a speed problem. May be, when the webcam
cannot treat quickly enough the requests, either it returns errors or
it crashes. An other cause could be a bug in the ohci_hcd, but I do not
looked at it. The delay was just a test and it fixed the problem. That
is all the user wanted...

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
