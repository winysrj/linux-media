Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:56305 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZK1SRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 13:17:12 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 2FF468180C2
	for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 19:17:13 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 25B5F81816C
	for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 19:17:11 +0100 (CET)
Date: Sat, 28 Nov 2009 19:17:17 +0100
From: Jean-Francois Moine <moinejf@free.fr>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca sunplus: propagate error for higher level
Message-ID: <20091128191717.5164a003@tele>
In-Reply-To: <4B10CD81.7060909@freemail.hu>
References: <4B093DDD.5@freemail.hu>
	<4B10CD81.7060909@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Nov 2009 08:13:05 +0100
Németh Márton <nm127@freemail.hu> wrote:

> what do you think about this patch?

Hi Márton,

There are many other drivers where the usb_control_msg() errors are not
tested nor propagated to higher levels. Generally, this does not matter:
the errors are signalled at the lowest level, and they seldom occur.
Thus, I don't think your patch is useful...

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
