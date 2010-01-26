Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:39627 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0AZSft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 13:35:49 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 2633681808C
	for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 19:35:43 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id F0964818245
	for <linux-media@vger.kernel.org>; Tue, 26 Jan 2010 19:35:40 +0100 (CET)
Date: Tue, 26 Jan 2010 19:37:26 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Setting up the exposure time of a webcam
Message-ID: <20100126193726.00bcbc00@tele>
In-Reply-To: <20100126170053.GA5995@pathfinder.pcs.usp.br>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Jan 2010 15:00:53 -0200
Nicolau Werneck <nwerneck@gmail.com> wrote:

> Hello. I have this very cheap webcam that I sent a patch to support on
> gspca the other day. The specific driver is the t613.
> 
> I changed the lens of this camera, and now my images are all too
> bright, what I believe is due to the much larger aperture of this new
> lens. So I would like to try setting up a smaller exposure time on the
> camera (I would like to do that for other reasons too).
> 
> The problem is there's no "exposure" option to be set when I call
> programs such as v4lctl. Does that mean there is definitely no way for
> me to control the exposure time? The hardware itself was not designed
> to allow me do that? Or is there still a chance I can create some C
> program that might do it, for example?
	[snip]

Hello Nicolau,

There are brightness, contrast, colors, autogain and some other video
controls for the t613 webcams. You must use a v4l2 compliant program to
change them, as vlc or v4l2ucp (but not cheese).

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
